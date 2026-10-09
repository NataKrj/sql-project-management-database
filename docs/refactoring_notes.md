# Refactoring notes

This repository is a portfolio-oriented refactor of the supplied 2023 database project. The original materials show the database evolving through table creation, later `ALTER TABLE` statements, datatype changes, key removal/re-creation, and subsequent data updates. The portfolio version therefore presents the **consolidated end-state model** rather than replaying the full debugging/migration history.

## Source-preserving changes

1. **Consistent identifiers and datatypes.** `project_id` is stored as `INTEGER`; registration and contact numbers are text; longer IDs use `VARCHAR` rather than fixed-width `CHAR`.
2. **Final employee values.** Where the source later updates employee dates or positions, the final updated values are used in `02_seed_data.sql`.
3. **Final role identifiers.** The report's final Roles table uses IDs `12`, `23`, and `35`, and the employee-role assignment rows use the same IDs. Those final IDs are used here, rather than the earlier insert values `2`, `3`, and `5`.
4. **Project-to-timesheet alignment.** The source report shows a shifted sequence of `project.timesheet_id` updates. Because each project timesheet ID itself embeds the matching project ID (for example `510743_AML` for project `510743`), the portfolio version aligns projects to those matching IDs. This is a documented correction for reproducibility rather than a silent reproduction of the intermediate mismatch.
5. **Employee workload query.** The original query joins multiple many-to-many assignment tables at once, which can multiply rows. The portfolio query aggregates project and proposal hours separately before joining them to employees.
6. **Profitability terminology.** The original project calls the calculation profit/loss. The portfolio version labels it an **illustrative opportunity-cost estimate** because it is based on accepted budget, hours and rejected-proposal effort rather than a full accounting cost model.

## What is not changed

The business entities, core relationships, sample records, analytical questions and overall PostgreSQL design are retained from the supplied project materials.
