/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts 
    and helps identify the most financially rewarding skills to acquire or improve
*/

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

/*
Key Observations
1. High-Paying Skills Are Specialized:
    Tools like PySpark ($208K), Bitbucket ($189K), and Couchbase ($160K) are highly specialized skills that command premium salaries.
    These tools are often used for advanced data engineering or software development tasks.
2. Common Data Science Libraries Are Moderately Paid:
    Libraries like Pandas ($151K) and NumPy ($143K) are essential for data analysis but do not command as high a salary as more niche tools like PySpark or Couchbase.
3. Cloud-Based and Big Data Tools Are Valued:
    Tools like Databricks ($141K) and Kubernetes ($132K) show the increasing demand for cloud computing and containerization skills.
4. Visualization and Reporting Tools Are on the Lower End:
    Tools like MicroStrategy ($121K) and Airflow ($126K) are important but do not offer salaries as high as programming or big data tools.
*/