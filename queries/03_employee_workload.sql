-- Employee workload analysis.
-- Separate aggregations avoid row multiplication across many-to-many assignment tables.

WITH project_hours AS (
    SELECT
        ep.employee_id,
        SUM(et.project_hours) AS project_hours
    FROM employee_project ep
    JOIN employee_timesheet et ON et.employee_project_id = ep.employee_project_id
    GROUP BY ep.employee_id
),
proposal_hours AS (
    SELECT
        epr.employee_id,
        SUM(et.proposal_hours) AS proposal_hours
    FROM employee_proposal epr
    JOIN employee_timesheet et ON et.employee_proposal_id = epr.employee_proposal_id
    GROUP BY epr.employee_id
)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    COALESCE(ph.project_hours, 0) AS project_hours,
    COALESCE(prh.proposal_hours, 0) AS proposal_hours,
    COALESCE(ph.project_hours, 0) + COALESCE(prh.proposal_hours, 0) AS total_hours
FROM employee e
LEFT JOIN project_hours ph ON ph.employee_id = e.employee_id
LEFT JOIN proposal_hours prh ON prh.employee_id = e.employee_id
ORDER BY total_hours DESC, e.last_name, e.first_name;
