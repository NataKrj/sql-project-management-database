-- PostgreSQL schema for the portfolio refactor of the 2023 project-management database.
-- The source exercise evolved through multiple ALTER statements; this file represents the consolidated final model.

DROP TABLE IF EXISTS employee_timesheet CASCADE;
DROP TABLE IF EXISTS employee_role CASCADE;
DROP TABLE IF EXISTS employee_proposal CASCADE;
DROP TABLE IF EXISTS employee_project CASCADE;
DROP TABLE IF EXISTS project CASCADE;
DROP TABLE IF EXISTS proposal CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS role CASCADE;
DROP TABLE IF EXISTS position CASCADE;
DROP TABLE IF EXISTS timesheet CASCADE;
DROP TABLE IF EXISTS client CASCADE;

CREATE TABLE client (
    client_id        INTEGER PRIMARY KEY,
    company_name     VARCHAR(100) NOT NULL,
    registration_no  VARCHAR(50) NOT NULL,
    address           VARCHAR(150),
    contact_number    VARCHAR(50),
    email             VARCHAR(100)
);

CREATE TABLE position (
    position_id       INTEGER PRIMARY KEY,
    position_name     VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE role (
    role_id           INTEGER PRIMARY KEY,
    role_name         VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employee (
    employee_id       INTEGER PRIMARY KEY,
    first_name        VARCHAR(50) NOT NULL,
    last_name         VARCHAR(50) NOT NULL,
    email             VARCHAR(100),
    contact_number    VARCHAR(50),
    position_id       INTEGER REFERENCES position(position_id),
    date_of_birth     DATE,
    start_date        DATE
);

CREATE TABLE timesheet (
    timesheet_id      VARCHAR(20) PRIMARY KEY,
    start_date        DATE NOT NULL,
    end_date          DATE,
    total_hours       INTEGER CHECK (total_hours IS NULL OR total_hours >= 0)
);

CREATE TABLE proposal (
    proposal_id       VARCHAR(20) PRIMARY KEY,
    client_id         INTEGER NOT NULL REFERENCES client(client_id),
    date_submitted    DATE,
    status            VARCHAR(20) NOT NULL CHECK (status IN ('Pending','Accepted','Rejected')),
    budget            INTEGER CHECK (budget IS NULL OR budget >= 0),
    timesheet_id      VARCHAR(20) UNIQUE REFERENCES timesheet(timesheet_id),
    request_date      DATE
);

CREATE TABLE project (
    project_id        INTEGER PRIMARY KEY,
    project_name      VARCHAR(100) NOT NULL,
    start_date        DATE NOT NULL,
    end_date          DATE,
    status            VARCHAR(20) NOT NULL CHECK (status IN ('Ongoing','Completed','Canceled','Cancelled')),
    client_id         INTEGER NOT NULL REFERENCES client(client_id),
    proposal_id       VARCHAR(20) NOT NULL UNIQUE REFERENCES proposal(proposal_id),
    timesheet_id      VARCHAR(20) NOT NULL UNIQUE REFERENCES timesheet(timesheet_id),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE employee_project (
    employee_project_id VARCHAR(50) PRIMARY KEY,
    project_id          INTEGER NOT NULL REFERENCES project(project_id),
    employee_id         INTEGER NOT NULL REFERENCES employee(employee_id),
    UNIQUE (project_id, employee_id)
);

CREATE TABLE employee_proposal (
    employee_proposal_id VARCHAR(50) PRIMARY KEY,
    employee_id          INTEGER NOT NULL REFERENCES employee(employee_id),
    proposal_id          VARCHAR(20) NOT NULL REFERENCES proposal(proposal_id),
    UNIQUE (proposal_id, employee_id)
);

CREATE TABLE employee_role (
    employee_role_id     VARCHAR(50) PRIMARY KEY,
    employee_id          INTEGER NOT NULL REFERENCES employee(employee_id),
    project_id           INTEGER NOT NULL REFERENCES project(project_id),
    role_id              INTEGER NOT NULL REFERENCES role(role_id),
    UNIQUE (employee_id, project_id, role_id)
);

CREATE TABLE employee_timesheet (
    employee_timesheet_id VARCHAR(50) PRIMARY KEY,
    timesheet_id          VARCHAR(20) NOT NULL REFERENCES timesheet(timesheet_id),
    employee_project_id   VARCHAR(50) REFERENCES employee_project(employee_project_id),
    employee_proposal_id  VARCHAR(50) REFERENCES employee_proposal(employee_proposal_id),
    work_date             DATE NOT NULL,
    project_hours         INTEGER CHECK (project_hours IS NULL OR project_hours >= 0),
    proposal_hours        INTEGER CHECK (proposal_hours IS NULL OR proposal_hours >= 0),
    CHECK (
        (employee_project_id IS NOT NULL AND employee_proposal_id IS NULL AND project_hours IS NOT NULL AND proposal_hours IS NULL)
        OR
        (employee_project_id IS NULL AND employee_proposal_id IS NOT NULL AND project_hours IS NULL AND proposal_hours IS NOT NULL)
    )
);

CREATE INDEX idx_proposal_client ON proposal(client_id);
CREATE INDEX idx_project_client ON project(client_id);
CREATE INDEX idx_employee_project_employee ON employee_project(employee_id);
CREATE INDEX idx_employee_proposal_employee ON employee_proposal(employee_id);
CREATE INDEX idx_employee_timesheet_date ON employee_timesheet(work_date);
CREATE INDEX idx_employee_timesheet_timesheet ON employee_timesheet(timesheet_id);
