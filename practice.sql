-- practice problem 1
SELECT
    jpf.job_schedule_type AS job_schedule_type,
    AVG(jpf.salary_year_avg) AS avg_annual_salary,
    AVG(jpf.salary_hour_avg) AS avg_hourly_salary
FROM job_postings_fact AS jpf

WHERE jpf.job_posted_date > '2023-06-01'
GROUP BY jpf.job_schedule_type
LIMIT 50;


-- practice problem 2
SELECT
    COUNT(jpf.job_id) AS job_posting_count,
    EXTRACT(YEAR FROM jpf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS year,
    EXTRACT(MONTH FROM jpf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month
FROM job_postings_fact AS jpf

WHERE EXTRACT(YEAR FROM jpf.job_posted_date) = 2023
GROUP BY  year, month
LIMIT 50;


-- practice problem 3
SELECT
    cd.name AS company_name
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id

WHERE 
    (EXTRACT(MONTH FROM jpf.job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') BETWEEN 4 AND 6) AND
    jpf.job_health_insurance = True
LIMIT 50;


-- practice problem 6
-- January 2023 job postings
CREATE TABLE January_2023_job_postings AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023 
    AND EXTRACT(MONTH FROM job_posted_date) = 1;

-- February 2023 job postings
CREATE TABLE February_2023_job_postings AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023 
    AND EXTRACT(MONTH FROM job_posted_date) = 2;

-- March 2023 job postings
CREATE TABLE March_2023_job_postings AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(YEAR FROM job_posted_date) = 2023 
    AND EXTRACT(MONTH FROM job_posted_date) = 3;


-- CASE practice problem 1
SELECT
    jpf.job_title_short AS job_title_short,
    jpf.job_location AS location,
    jpf.salary_year_avg AS salary_year_avg,
    CASE
        WHEN jpf.salary_year_avg > 50000 THEN 'High Salary'
        WHEN jpf.salary_year_avg BETWEEN 30000 AND 50000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM job_postings_fact AS jpf
WHERE jpf.job_title_short = 'Data Analyst'
ORDER BY jpf.salary_year_avg

-- subquery practice problem 1
SELECT
    COUNT(sjd.skill_id) AS skill_count,
    sd.skills AS skill_name
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
GROUP BY skill_name
ORDER BY skill_count DESC
LIMIT 5;

-- ChatGPT
SELECT 
    COUNT(sub.skill_id) AS skill_count,
    sub.skill_name
FROM (
    -- Subquery: Join skills_job_dim with skills_dim to get skill_id and skill_name
    SELECT 
        sjd.skill_id, 
        sd.skills AS skill_name
    FROM skills_job_dim AS sjd
    LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
) AS sub
GROUP BY sub.skill_name
ORDER BY skill_count DESC
LIMIT 5;


-- subquery practice problem 2
SELECT *
    CASE 
        WHEN COUNT(jpf.job_id) > 100 THEN 'Large'
        WHEN COUNT(jpf.job_id) BETWEEN 50 AND 100 THEN 'Medium'
        ELSE 'Small'
    END AS size_category
FROM job_postings_fact AS jpf


SELECT
    sub.company_name,
    sub.job_posting_count,
    CASE
        WHEN sub.job_posting_count < 10 THEN 'Small'
        WHEN sub.job_posting_count < 50 THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM(
    SELECT 
        COUNT(jpf.job_id) AS job_posting_count,
        cd.name AS company_name
    FROM job_postings_fact AS jpf
    LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
    GROUP BY cd.name
) AS sub

LIMIT 50;

-- UNION practice problem 1

SELECT 
    jp01.job_id,
    jp01.job_id AS job_id_01
FROM january_2023_job_postings AS jp01

UNION

SELECT 
    jp02.job_id
FROM february_2023_job_postings AS jp02

UNION

SELECT 
    jp03.job_id
FROM march_2023_job_postings AS jp03

LEFT JOIN skills_job_dim AS sjd ON jp01.job_id = sjd.job_id

-- ChatGPT
SELECT 
    q1_jobs.job_id,
    s.skills,
    s.type
FROM (
    -- Get all jobs from Q1 with salary > 70,000
    SELECT job_id FROM january_2023_job_postings WHERE salary_year_avg > 70000
    UNION
    SELECT job_id FROM february_2023_job_postings WHERE salary_year_avg > 70000
    UNION
    SELECT job_id FROM march_2023_job_postings WHERE salary_year_avg > 70000
) AS q1_jobs
LEFT JOIN skills_job_dim AS sjd ON q1_jobs.job_id = sjd.job_id
LEFT JOIN skills_dim AS s ON sjd.skill_id = s.skill_id;
