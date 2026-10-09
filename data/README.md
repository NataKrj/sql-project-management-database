# Data files

This folder contains the cleaned data used by the portfolio version of the project.

- `02_seed_data.sql` — small reference tables and relationship data consolidated from the original SQL source.
- `employee_timesheet.csv` — 3,676 employee-level project/proposal time entries; headers standardized and dates converted to ISO `YYYY-MM-DD`.
- `timesheet_daily.csv` — 3,170 daily timesheet rows; four completely empty `Unnamed` columns from the original export were removed and dates standardized.
- `working_dates.csv` — 556 working-date records standardized to ISO format.
- `03_load_employee_timesheet.sql` — psql `\copy` helper for loading `employee_timesheet.csv`.

The values originate from the supplied project materials. Cleaning is limited to column naming, date formatting, removal of empty export columns, and the documented schema refactor. No confidential employer or client data are introduced by this portfolio package.
