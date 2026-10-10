
USE recruiterflow_assignment;

-- Question 1: List all open job postings with their recruiter names
SELECT
    jp.id AS job_id,
    jp.title AS job_title,
    r.name AS recruiter_name
FROM job_postings jp
JOIN recruiters r
    ON jp.recruiter_id = r.id
WHERE jp.status = 'open';


-- Question 2: Count applicants who reached the Final interview stage for each job posting

SELECT
    jp.id AS job_id,
    jp.title AS job_title,
    COUNT(DISTINCT i.applicant_id) AS final_stage_applicants
FROM job_postings jp
LEFT JOIN interviews i
    ON jp.id = i.job_posting_id
    AND i.stage = 'Final'
GROUP BY jp.id, jp.title
ORDER BY jp.id;

-- Question 3: Find people who effectively applied to more than one job posting

SELECT
    a.full_name,
    LOWER(TRIM(a.email)) AS normalized_email,
    COUNT(DISTINCT i.job_posting_id) AS jobs_applied_to
FROM applicants a
JOIN interviews i
    ON a.id = i.applicant_id
WHERE a.email IS NOT NULL
GROUP BY a.full_name, LOWER(TRIM(a.email))
HAVING COUNT(DISTINCT i.job_posting_id) > 1;


-- Question 4: Final-stage conversion rate per recruiter,

SELECT
    r.id AS recruiter_id,
    r.name AS recruiter_name,
    COUNT(*) AS total_final_interviews,
    SUM(CASE WHEN i.outcome = 'passed' THEN 1 ELSE 0 END)
        AS passed_final_interviews,
    ROUND(
        100.0 * SUM(CASE WHEN i.outcome = 'passed' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS conversion_rate_percent
FROM recruiters r
JOIN job_postings jp
    ON r.id = jp.recruiter_id
JOIN interviews i
    ON jp.id = i.job_posting_id
WHERE i.stage = 'Final'
GROUP BY r.id, r.name
HAVING COUNT(*) >= 3
ORDER BY conversion_rate_percent DESC;


-- Question 5 : Recruiter with the most successful placements per department
WITH recruiter_placements AS (
    SELECT
        jp.department,
        r.id AS recruiter_id,
        r.name AS recruiter_name,
        COUNT(*) AS successful_placements
    FROM job_postings jp
    JOIN recruiters r
        ON jp.recruiter_id = r.id
    JOIN interviews i
        ON jp.id = i.job_posting_id
    WHERE i.stage = 'Final'
      AND i.outcome = 'passed'
    GROUP BY jp.department, r.id, r.name
),
ranked_placements AS (
    SELECT
        department,
        recruiter_id,
        recruiter_name,
        successful_placements,
        RANK() OVER (
            PARTITION BY department
            ORDER BY successful_placements DESC
        ) AS placement_rank
    FROM recruiter_placements
)
SELECT
    department,
    recruiter_id,
    recruiter_name,
    successful_placements
FROM ranked_placements
WHERE placement_rank = 1
ORDER BY department;
