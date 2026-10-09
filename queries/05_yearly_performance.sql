-- Yearly activity summary.
-- FULL OUTER JOIN retains a year even if it appears only in proposal or project effort.

WITH accepted_proposal_hours AS (
    SELECT
        EXTRACT(YEAR FROM t.start_date)::int AS year,
        SUM(t.total_hours) AS accepted_proposal_hours
    FROM timesheet t
    JOIN proposal pr ON pr.timesheet_id = t.timesheet_id
    WHERE pr.status = 'Accepted'
    GROUP BY EXTRACT(YEAR FROM t.start_date)
),
project_hours AS (
    SELECT
        EXTRACT(YEAR FROM et.work_date)::int AS year,
        SUM(et.project_hours) AS project_hours
    FROM employee_timesheet et
    WHERE et.project_hours IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM et.work_date)
)
SELECT
    COALESCE(a.year, p.year) AS year,
    COALESCE(a.accepted_proposal_hours, 0) AS accepted_proposal_hours,
    COALESCE(p.project_hours, 0) AS project_hours,
    COALESCE(a.accepted_proposal_hours, 0) + COALESCE(p.project_hours, 0) AS total_delivery_hours
FROM accepted_proposal_hours a
FULL OUTER JOIN project_hours p ON p.year = a.year
ORDER BY year;
