# Multi-Node Storage Provisioning and Cross-Node Migration

## Problem
When node 1 (10.99) has insufficient space for a new storage request (e.g., 7GB requested, 3GB available), the system fails immediately instead of checking node 2 (10.88, 289GB free). Similarly, upgrades that exceed current node capacity should migrate data to the next available node.

## Approach
- **rsync over SSH** for cross-node data migration
- **Provision-only scope** — NVMe-oF session transport deferred
- Users provisioned on node 2 will use the existing NFS mount path for now

---

## Task 1: Fix New Provisioning to Use Multi-Node Fallback

**File**: `backend-new/src/storage/storage.controller.ts` (POST /volumes handler, ~lines 150-260)

**Current behavior**: The handler calls `getHostSpace()` on a single node. If that node is full, it throws `BadRequestException("Insufficient host storage space")`.

**Required change**: Replace the single-node space check with the existing `nodeService.selectStorageNode(quotaGb)` which already implements sequential fill across all healthy nodes. The node service already queries `/host-space` on each node and respects headroom thresholds.

Specifically:
1. Call `nodeService.selectStorageNode(additionalGb)` to get the best-fit node
2. If no node returned, throw error: "Insufficient space across all nodes"
3. Build the provision URL using `nodeService.getStorageProvisionUrl(selectedNode)`
4. POST to that node's `/provision` endpoint with the storage UID and quota
5. Save `nodeId` and `storageBackend` on the `UserStorageVolume` record

The `selectStorageNode()` method (node.service.ts lines 249-317) already handles the sequential fill logic correctly — it queries all healthy nodes, checks real-time space via `/host-space`, and returns the first node with sufficient capacity including headroom.

---

## Task 2: Add Flask Migration Endpoints to Host Service

**File**: `host-services/storage-provision/app.py`

Add three new endpoints for cross-node migration:

### `POST /migrate-export`
- **Params**: `storageUid`, `targetHost`, `targetPath`
- **Logic**:
  1. Resolve source path: `/datapool/users/{storageUid}`
  2. Validate source exists and has data
  3. Execute `rsync -avz --progress {sourcePath}/ {targetHost}:{targetPath}/` over SSH
  4. Return `{success, bytesSent, fileCount, elapsed}`
- **Timeout**: Base 120s + 30s per GB of data
- **Auth**: Uses pre-configured SSH key between nodes

### `POST /verify-migration`
- **Params**: `storageUid`, `expectedFileCount`, `expectedBytes`
- **Logic**:
  1. Check local dataset: `/datapool/users/{storageUid}`
  2. Count files and total bytes via `du -sb` and `find | wc -l`
  3. Compare with expected values (5% tolerance)
  4. Return `{verified: bool, localFiles, localBytes, match}`

### `POST /migrate-cleanup`
- **Params**: `storageUid`
- **Logic**:
  1. Deprovision the old dataset: `zfs destroy datapool/users/{storageUid}`
  2. Remove NFS export if exists
  3. Best-effort — log failures but don't throw

---

## Task 3: Implement Backend Migration Orchestration

**File**: `backend-new/src/storage/storage.service.ts`

### Add `migrateStorage()` method (if not already complete):
```
async migrateStorage(
  volume: UserStorageVolume,
  sourceNode: Node,
  targetNode: Node,
  newQuotaGb: number
): Promise<{success, migratedBytes, migratedFiles}>
```

**Orchestration flow**:
1. **Pre-flight**: Verify target node has space via `checkNodeSpace(targetNode.id, newQuotaGb)`
2. **Provision on target**: POST to target's `/provision` with storageUid and newQuotaGb
3. **Export from source**: POST to source's `/migrate-export` with targetHost = targetNode.ipStorage (10GbE IP), targetPath = `/datapool/users/{storageUid}`
4. **Verify on target**: POST to target's `/verify-migration` with file/byte counts from export
5. **DB transaction**: Update `volume.nodeId` to targetNode.id, update `volume.quotaGb`, update `volume.storageBackend`
6. **Cleanup source**: POST to source's `/migrate-cleanup` (best-effort)
7. **On failure at any step**: Attempt rollback — deprovision target if created, keep source intact

---

## Task 4: Wire Migration into Upgrade Flow

**File**: `backend-new/src/storage/storage.controller.ts` (PATCH /volumes/:id handler)

The upgrade handler (lines ~795-1180) reportedly already has partial multi-node migration logic. Verify and complete:

1. Check if current node has space for the upgrade (in-place path)
2. If NOT: Call `nodeService.selectStorageNode(newQuotaGb)` to find alternate node
3. If alternate found: Call `storageService.migrateStorage()` with source/target nodes
4. Update response to include `migrated: true`, `previousNodeId`, `newNodeId`, `previousNodeHostname`, `newNodeHostname`
5. If NO node has space: Return clear error "Insufficient space across all nodes: {node1}: {avail1}GB, {node2}: {avail2}GB"

---

## Task 5: Frontend — Handle Multi-Node Provisioning Response

**File**: `frontend-new/src/app/(console)/storage/page.tsx`

Minor changes:
1. After successful provisioning, the response now includes `nodeHostname` — already displayed as "Stored on {hostname}"
2. For upgrades that trigger migration, show a brief "Storage migrated to {newNodeHostname}" success toast
3. Update error message for insufficient space to show: "Insufficient space across all nodes" (not just single-node error)

---

## Task 6: Verify End-to-End

1. **New provisioning fallback**: With node 1 nearly full, create a 7GB volume — should auto-provision on node 2
2. **In-place upgrade**: Upgrade a volume on a node with sufficient space — should stay on same node
3. **Cross-node migration**: Upgrade a volume beyond node 1's capacity — should migrate to node 2 via rsync
4. **Error case**: Request more storage than ALL nodes combined — should show clear multi-node error
5. **DB validation**: Verify `nodeId`, `storageBackend` are correctly set after each operation

---

## Files Changed Summary

| File | Change |
|------|--------|
| `backend-new/src/storage/storage.controller.ts` | Multi-node fallback in POST /volumes; complete migration flow in PATCH /volumes/:id |
| `backend-new/src/storage/storage.service.ts` | `migrateStorage()` orchestration method |
| `host-services/storage-provision/app.py` | Add `/migrate-export`, `/verify-migration`, `/migrate-cleanup` endpoints |
| `frontend-new/src/app/(console)/storage/page.tsx` | Migration success toast, multi-node error messages |

## Deferred (Follow-up)
- NVMe-oF target auto-setup on zvol creation
- Session orchestration NVMe-oF discover/connect/mount
- Compute service storage transport field population
- Frontend storage transport display in instance details
