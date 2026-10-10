# Build-a-Recruiter-Bot

## Overview

A backend service that ranks fictional candidates against job openings based on skill overlap and experience fit. Built using Java, Spring Boot, MySQL, and Spring JDBC (`JdbcTemplate`), using handwritten SQL without an ORM or query builder.

## Prerequisites

- Java 21 or later
- MySQL Server

## Setup and Run

1. Create the database:

```sql
CREATE DATABASE recruiter_bot;
```

2. Create and populate the `candidates`, `jobs`, `candidate_skills`, and `job_required_skills` tables with the assignment's seed data.

3. Configure database credentials in the environment. In Windows PowerShell:

```powershell
$env:DB_URL = "jdbc:mysql://localhost:3306/recruiter_bot"
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "YOUR_MYSQL_PASSWORD"
```

4. Run the tests and start the application:

```powershell
.\mvnw.cmd test
.\mvnw.cmd spring-boot:run
```

## API Endpoints

- `GET /jobs/{id}/matches` — Returns candidates ranked for a job.
- `GET /candidates/{id}/matches` — Returns jobs ranked for a candidate.
- `GET /api/health` — Checks database connectivity.

Matching responses include matched and missing skills, skill score, experience score, and overall match score. Invalid candidate or job IDs return `404 Not Found`.

## Matching Algorithm and Trade-offs

The matching score combines skill overlap (70%) and experience fit (30%). The skill score is the percentage of required job skills possessed by the candidate. The experience score is proportional to the candidate's experience relative to the job's minimum requirement, capped at 100.

The overall score is calculated as `(0.70 × Skill Score) + (0.30 × Experience Score)`. Candidates with no overlapping required skills have their overall score capped at 20. Candidates below the minimum experience requirement remain in the results, with their experience fit reflected in the score. Culture keywords are stored but are not included in the numerical score.

The schema separates candidates, jobs, candidate skills, and required job skills into relational tables. JDBC was chosen to keep SQL explicit and avoid ORM-generated queries.

## SQL Detective

`sql_detective.sql` contains the five SQL answers, each preceded by its question number. It covers open jobs, Final-stage applicants, people associated with multiple jobs, recruiter conversion rates, and successful placements by department.

The SQL Detective dataset uses the separate `recruiterflow_assignment` database. Since it has no applications table, Question 3 uses interview records as a proxy for applications.

## AI Assistance Disclosure

ChatGPT was used to clarify requirements, discuss schema and matching algorithm design, troubleshoot Spring Boot and MySQL configuration, develop and review SQL queries, and prepare documentation. I reviewed the explanations to understand the implementation and its trade-offs and am responsible for explaining the submitted solution.