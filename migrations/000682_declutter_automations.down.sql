-- 000682_declutter_automations.down.sql
DELETE FROM automations WHERE name IN (
    'Auto-close out-of-office and bounce notifications',
    'Prevent courtesy replies from reopening solved tickets',
    'Auto-triage and prioritize billing & refund requests',
    'Auto-triage and prioritize bug & crash reports',
    'Auto-tag and deprioritize automated no-reply senders'
);

