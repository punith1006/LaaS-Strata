# Student Live Session Accordion

## Task: Replace StudentLiveSection with accordion

**File**: `frontend-new/src/components/mentor/mentor-user-sessions-tab.tsx`

Replace the entire `StudentLiveSection` function (lines 745-778) with an accordion version following the exact same pattern as `RequestsTable` and `UpcomingTable` in this file.

### Add accordion state inside StudentLiveSection:
```typescript
const [expandedId, setExpandedId] = useState<string | null>(null);
const [collapsingId, setCollapsingId] = useState<string | null>(null);
const [panelMaxHeight, setPanelMaxHeight] = useState(400);
const panelRef = useRef<HTMLDivElement>(null);
const containerRef = useRef<HTMLDivElement>(null);
const [mentorProfile, setMentorProfile] = useState<MentorProfileDetail | null>(null);
```

### Add handleRowClick + orderedSessions + animation effects + profile fetch
Same pattern as UpcomingTable: handleRowClick, orderedSessions (reorder with expanded first), requestAnimationFrame for open, setTimeout for collapse, getMentorProfileForAccordion on expand.

### Modify row rendering
- Rows become clickable with cursor: pointer and onClick handler
- Wrap row and expandable panel in a `<div key={s.id}>`
- Add stopPropagation (no action dropdown here, but keep for future)

### Add expanded panel (same as student UpcomingTable accordion)
Below each row, when `isExpanded || isCollapsing`:
- Identity bar: mentor email+verified, college info, expertise level
- Account/Socials 2-column grid
- No Session Info section (StudentLiveEntry doesn't have subject/studentNotes fields)

### Keep existing:
- pulse animation for Live status
- Start time display
- Duration display
- Styling consistency

## Verification
- `npx tsc --noEmit` in frontend-new/
