-- CreateTable
CREATE TABLE "support_ticket_attachments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "ticketId" UUID NOT NULL,
    "fileName" VARCHAR(255) NOT NULL,
    "mimeType" VARCHAR(64) NOT NULL,
    "size" INTEGER NOT NULL,
    "data" BYTEA NOT NULL,
    "createdAt" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_ticket_attachments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "support_ticket_attachments_ticketId_idx" ON "support_ticket_attachments"("ticketId");

-- AddForeignKey
ALTER TABLE "support_ticket_attachments" ADD CONSTRAINT "support_ticket_attachments_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "support_tickets"("id") ON DELETE CASCADE ON UPDATE CASCADE;