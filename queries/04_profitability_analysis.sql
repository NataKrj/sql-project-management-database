-- Illustrative profitability / opportunity-cost estimate.
-- This preserves the analytical idea from the source project; it is not an accounting P&L.

WITH accepted AS (
    SELECT
        SUM(pr.budget)::numeric AS accepted_budget,
        SUM(t.total_hours)::numeric AS accepted_proposal_hours
    FROM proposal pr
    JOIN timesheet t ON t.timesheet_id = pr.timesheet_id
    WHERE pr.status = 'Accepted'
),
project_effort AS (
    SELECT COALESCE(SUM(project_hours), 0)::numeric AS project_hours
    FROM employee_timesheet
    WHERE project_hours IS NOT NULL
),
rejected_effort AS (
    SELECT COALESCE(SUM(t.total_hours), 0)::numeric AS rejected_proposal_hours
    FROM proposal pr
    JOIN timesheet t ON t.timesheet_id = pr.timesheet_id
    WHERE pr.status = 'Rejected'
),
rate AS (
    SELECT
        a.accepted_budget,
        a.accepted_proposal_hours,
        pe.project_hours,
        re.rejected_proposal_hours,
        a.accepted_budget / NULLIF(a.accepted_proposal_hours + pe.project_hours, 0) AS implied_income_per_hour
    FROM accepted a
    CROSS JOIN project_effort pe
    CROSS JOIN rejected_effort re
)
SELECT
    ROUND(accepted_budget, 2) AS accepted_budget,
    ROUND(implied_income_per_hour, 2) AS implied_income_per_hour,
    ROUND(rejected_proposal_hours * implied_income_per_hour, 2) AS estimated_opportunity_cost,
    ROUND(accepted_budget - rejected_proposal_hours * implied_income_per_hour, 2) AS illustrative_net_value
FROM rate;
