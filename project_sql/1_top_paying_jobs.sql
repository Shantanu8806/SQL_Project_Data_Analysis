-- Question:What are the top-paying data analyst jobs?
-- -Identify the top highest-paying Data analyst roles that are available remotely
-- -Focuses on job postings with specified salaries(remove nulls)
-- -Why? Highlight the top paying opportunities for data analysts

SELECT 
    cd.name as company_name,
    jpf.job_id,
    jpf.job_title,
    jpf.job_location,
    jpf.job_schedule_type,
    jpf.salary_year_avg,
    jpf.job_posted_date
FROM
    job_postings_fact as jpf
LEFT JOIN company_dim as cd
ON jpf.company_id = cd.company_id
WHERE
    jpf.job_title_short = 'Data Analyst'AND 
    jpf.job_location = 'Anywhere' AND
    jpf.salary_year_avg IS NOT NULL
ORDER BY
    jpf.salary_year_avg DESC
LIMIT 10