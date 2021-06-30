
SELECT id, name 
FROM `leslunes-raw.zendesk.users`
WHERE role in('agent', 'admin')
GROUP BY 1,2
