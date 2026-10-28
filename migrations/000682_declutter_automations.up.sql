-- 000682_declutter_automations.up.sql
-- Declutter automations: auto-close bounces, prevent solved reopening on courtesy thanks, and auto-triage tags.

INSERT INTO automations (id, workspace_id, name, trigger, conditions, actions, enabled, position)
SELECT 
    gen_random_uuid(),
    w.id,
    'Auto-close out-of-office and bounce notifications',
    'ticket_created',
    '[{"field": "subject", "op": "any", "value": "out of office\nautomatic reply\nauto-reply\nundeliverable\ndelivery status notification\nfailure notice"}]'::jsonb,
    '[{"type": "set_status", "value": "closed"}, {"type": "add_tag", "value": "notification"}]'::jsonb,
    true,
    0
FROM workspaces w
WHERE NOT EXISTS (
    SELECT 1 FROM automations a WHERE a.workspace_id = w.id AND a.name = 'Auto-close out-of-office and bounce notifications'
);

INSERT INTO automations (id, workspace_id, name, trigger, conditions, actions, enabled, position)
SELECT 
    gen_random_uuid(),
    w.id,
    'Prevent courtesy replies from reopening solved tickets',
    'customer_replied',
    '[{"field": "status", "op": "equals", "value": "solved"}, {"field": "body", "op": "any", "value": "thank you\nthanks!\nthanks so much\nappreciated\nthank you so much\nall good now"}]'::jsonb,
    '[{"type": "set_status", "value": "solved"}, {"type": "add_tag", "value": "courtesy-reply"}]'::jsonb,
    true,
    1
FROM workspaces w
WHERE NOT EXISTS (
    SELECT 1 FROM automations a WHERE a.workspace_id = w.id AND a.name = 'Prevent courtesy replies from reopening solved tickets'
);

INSERT INTO automations (id, workspace_id, name, trigger, conditions, actions, enabled, position)
SELECT 
    gen_random_uuid(),
    w.id,
    'Auto-triage and prioritize billing & refund requests',
    'ticket_created',
    '[{"field": "subject", "op": "any", "value": "refund\ninvoice\nbilling\ncharge\nsubscription\npayment failed"}]'::jsonb,
    '[{"type": "add_tag", "value": "Billing"}, {"type": "set_priority", "value": "high"}]'::jsonb,
    true,
    2
FROM workspaces w
WHERE NOT EXISTS (
    SELECT 1 FROM automations a WHERE a.workspace_id = w.id AND a.name = 'Auto-triage and prioritize billing & refund requests'
);

INSERT INTO automations (id, workspace_id, name, trigger, conditions, actions, enabled, position)
SELECT 
    gen_random_uuid(),
    w.id,
    'Auto-triage and prioritize bug & crash reports',
    'ticket_created',
    '[{"field": "subject", "op": "any", "value": "crash\nfatal error\nbug\nbroken\n500 internal server error\nexception"}]'::jsonb,
    '[{"type": "add_tag", "value": "Bug"}, {"type": "set_priority", "value": "urgent"}]'::jsonb,
    true,
    3
FROM workspaces w
WHERE NOT EXISTS (
    SELECT 1 FROM automations a WHERE a.workspace_id = w.id AND a.name = 'Auto-triage and prioritize bug & crash reports'
);

INSERT INTO automations (id, workspace_id, name, trigger, conditions, actions, enabled, position)
SELECT 
    gen_random_uuid(),
    w.id,
    'Auto-tag and deprioritize automated no-reply senders',
    'ticket_created',
    '[{"field": "from_email", "op": "any", "value": "no-reply@\nnoreply@\nmailer-daemon@\nnotifications@"}]'::jsonb,
    '[{"type": "add_tag", "value": "notification"}, {"type": "set_priority", "value": "low"}]'::jsonb,
    true,
    4
FROM workspaces w
WHERE NOT EXISTS (
    SELECT 1 FROM automations a WHERE a.workspace_id = w.id AND a.name = 'Auto-tag and deprioritize automated no-reply senders'
);

