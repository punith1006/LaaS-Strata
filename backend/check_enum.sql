SELECT enumlabel, enumsortorder FROM pg_enum WHERE enumtypid = (SELECT oid FROM pg_type WHERE typname='MentorSessionType') ORDER BY enumsortorder;
