-- SELECT DISTINCT job_location
-- FROM job_postings_fact
-- ORDER BY job_location;

-- SELECT DISTINCT job_title_short
-- FROM job_postings_fact
-- ORDER BY job_title_short;

-- SELECT 
--     job_title_short, 
--     job_location
-- FROM job_postings_fact
-- ORDER BY job_location;

SELECT *
FROM job_postings_fact
LIMIT 10;


SELECT 
    job_via,
    job_count,
    job_percentage
FROM (
    SELECT 
        job_via,
        COUNT(jpf.*) AS job_count,
        (ROUND(COUNT(jpf.*) * 100.0 / SUM(COUNT(jpf.*)) OVER (), 0) || '%') AS job_percentage
    FROM job_postings_fact AS jpf
    GROUP BY job_via
) AS subquery
WHERE job_count > 5 AND (ROUND(job_count * 100.0 / (SELECT SUM(job_count) FROM (
    SELECT COUNT(jpf.*) AS job_count
    FROM job_postings_fact AS jpf
    GROUP BY job_via
) AS total_counts), 0)) >= 1
ORDER BY job_count DESC;