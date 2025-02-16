/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
    offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT
        sd.skill_id,
        sd.skills,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
),
    average_salary AS (
    SELECT
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skill_id
)
    
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;