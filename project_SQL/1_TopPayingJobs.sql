/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering insights into employment trends and salary expectations.
*/

SELECT
    name AS company_name,
    job_title,
    job_location,
    CAST(salary_year_avg AS INTEGER) AS salary_year_avg  
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short IN ('Data Analyst' , 
                        'Data Engineer', 
                        'Data Scientist', 
                        'Machine Learning Engineer')
    AND (job_location = 'Anywhere' OR job_location LIKE '%, WA%')
    -- AND (job_location LIKE '%,wa%')
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 100;
