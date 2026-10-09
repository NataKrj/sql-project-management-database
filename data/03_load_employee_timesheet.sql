-- Load the cleaned detailed employee time entries in psql.
-- Run this file from the repository root with psql so the relative path resolves.
-- If your psql working directory differs, adjust the file path.

\copy employee_timesheet (
    employee_timesheet_id,
    timesheet_id,
    employee_project_id,
    employee_proposal_id,
    work_date,
    project_hours,
    proposal_hours
) FROM 'data/employee_timesheet.csv' WITH (FORMAT csv, HEADER true, NULL '');
