-- Basic integrity checks for the portfolio dataset.

-- Employee time rows should point to exactly one assignment type.
SELECT COUNT(*) AS invalid_employee_timesheet_rows
FROM employee_timesheet
WHERE NOT (
    (employee_project_id IS NOT NULL AND employee_proposal_id IS NULL AND project_hours IS NOT NULL AND proposal_hours IS NULL)
    OR
    (employee_project_id IS NULL AND employee_proposal_id IS NOT NULL AND project_hours IS NULL AND proposal_hours IS NOT NULL)
);

-- Check for employee-project assignments without a matching employee.
SELECT COUNT(*) AS orphan_employee_project_rows
FROM employee_project ep
LEFT JOIN employee e ON e.employee_id = ep.employee_id
WHERE e.employee_id IS NULL;

-- Check for proposal rows without a client.
SELECT COUNT(*) AS orphan_proposals
FROM proposal pr
LEFT JOIN client c ON c.client_id = pr.client_id
WHERE c.client_id IS NULL;
