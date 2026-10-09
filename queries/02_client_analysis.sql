-- Client relationship and proposal-outcome analysis.

-- 1. Cooperation period since the first recorded client request.
SELECT
    c.client_id,
    c.company_name,
    MIN(pr.request_date) AS cooperation_start_date,
    AGE(CURRENT_DATE, MIN(pr.request_date)) AS cooperation_period
FROM client c
JOIN proposal pr ON pr.client_id = c.client_id
GROUP BY c.client_id, c.company_name
ORDER BY cooperation_start_date;

-- 2. Client-level proposal statistics.
WITH client_stats AS (
    SELECT
        c.client_id,
        c.company_name,
        COUNT(*) AS proposal_count,
        SUM(pr.budget) AS total_budget,
        SUM(t.total_hours) AS total_proposal_hours,
        SUM(t.total_hours) FILTER (WHERE pr.status = 'Accepted') AS accepted_hours,
        SUM(t.total_hours) FILTER (WHERE pr.status = 'Rejected') AS rejected_hours
    FROM client c
    JOIN proposal pr ON pr.client_id = c.client_id
    JOIN timesheet t ON t.timesheet_id = pr.timesheet_id
    GROUP BY c.client_id, c.company_name
)
SELECT *
FROM client_stats
ORDER BY total_proposal_hours DESC, company_name;
