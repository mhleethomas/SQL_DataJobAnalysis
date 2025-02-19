# SQL Data Job Analysis

## Introduction
This project aims to analyze job postings for Data Analyst roles to identify trends in salaries, required skills, and demand for specific skills. The analysis focuses on remote positions with specified salaries to provide insights into the top-paying opportunities and the most valuable skills for job seekers.

## Background
The data for this project is sourced from various CSV files containing information about job postings, companies, and required skills. The analysis is performed using SQL queries to extract meaningful insights from the data.

## Tools I Used
- PostgreSQL: For running SQL queries and managing the database.
- Visual Studio Code: As the code editor for writing and managing SQL scripts.
- CSV files: Containing data about job postings, companies, and skills.

## The Analysis
The analysis is divided into several SQL scripts, each focusing on a specific aspect of the data:

1. **Top Paying Jobs** ([1_TopPayingJobs.sql](project_SQL/1_TopPayingJobs.sql))
    - Identifies the top 10 highest-paying Data Analyst roles that are available remotely.
    - Focuses on job postings with specified salaries.

    ```sql
    SELECT
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' 
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10;
    ```

2. **Top Paying Job Skills** (2_TopPayingJobSkills.sql)
    - Identifies the specific skills required for the top 10 highest-paying Data Analyst jobs.

    ```sql
    WITH top_paying_jobs AS (
        SELECT
            jpf.job_id,
            jpf.job_title,
            jpf.salary_year_avg,
            cd.name AS company_name
        FROM
            job_postings_fact AS jpf
        LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
        WHERE 
            jpf.job_title_short = 'Data Analyst'
            AND jpf.job_location = 'Anywhere'
            AND jpf.salary_year_avg IS NOT NULL
        ORDER BY jpf.salary_year_avg DESC
        LIMIT 10
    ) 

    SELECT 
        tpj.*,
        sd.skills
    FROM top_paying_jobs AS tpj
    INNER JOIN skills_job_dim AS sjd ON tpj.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    ORDER BY 
        tpj.salary_year_avg DESC;
    ```

3. **Top Demanded Skills** (3_TopDemandedSkills.sql)
    - Identifies the top 5 in-demand skills for Data Analyst roles.

    ```sql
    SELECT
        sd.skills,
        COUNT(jpf.job_id) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skills
    ORDER BY
        demand_count DESC
    LIMIT 5;
    ```

4. **Top Paying Skills** (4_TopPayingSkills.sql)
    - Identifies the top skills based on the average salary for Data Analyst positions.

    ```sql
    SELECT
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
        sd.skills
    ORDER BY
        avg_salary DESC
    LIMIT 25;
    ```

5. **Optimal Skills** (5_OptimalSkills.sql)
    - Identifies the most optimal skills to learn, which are in high demand and associated with high average salaries for Data Analyst roles.

    ```sql
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
    ```

## What I Learned
- **High-Paying Jobs**: The top-paying Data Analyst roles are often remote positions with specified salaries.
- **In-Demand Skills**: SQL, Python, and Tableau are among the most commonly required skills for high-paying Data Analyst jobs.
- **Optimal Skills**: Skills that are both in high demand and associated with high salaries include specialized tools like PySpark, Bitbucket, and Couchbase.
- **Data Analysis**: The importance of joining tables and using aggregate functions to extract meaningful insights from the data.
