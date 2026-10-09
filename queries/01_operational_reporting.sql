-- Operational reporting: project/proposal effort and project staffing.

-- 1. Total hours recorded for each client's project.
SELECT
    c.company_name,
    p.project_name,
    t.total_hours
FROM project p
JOIN client c ON c.client_id = p.client_id
JOIN timesheet t ON t.timesheet_id = p.timesheet_id
ORDER BY t.total_hours DESC, c.company_name;

-- 2. Total hours recorded for each client's proposal.
SELECT
    c.company_name,
    pr.proposal_id,
    pr.status,
    t.total_hours
FROM proposal pr
JOIN client c ON c.client_id = pr.client_id
JOIN timesheet t ON t.timesheet_id = pr.timesheet_id
ORDER BY t.total_hours DESC, c.company_name;

-- 3. Average employee hours per proposal workday.
SELECT ROUND(AVG(proposal_hours)::numeric, 2) AS avg_proposal_hours_per_entry
FROM employee_timesheet
WHERE proposal_hours IS NOT NULL;

-- 4. Employees assigned to a selected project.
-- Replace 487325 with another project_id as required.
SELECT e.employee_id, e.first_name, e.last_name
FROM employee e
JOIN employee_project ep ON ep.employee_id = e.employee_id
WHERE ep.project_id = 487325
ORDER BY e.last_name, e.first_name;
