WITH top_paying_jobs AS(
    SELECT cd.name as company_name,
        jpf.job_id,
        jpf.job_title,
        jpf.job_location,
        jpf.job_schedule_type,
        jpf.salary_year_avg,
        jpf.job_posted_date
    FROM job_postings_fact as jpf
        LEFT JOIN company_dim as cd ON jpf.company_id = cd.company_id
    WHERE jpf.job_title_short = 'Data Analyst'
        AND jpf.job_location = 'Anywhere'
        AND jpf.salary_year_avg IS NOT NULL
    ORDER BY jpf.salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*,
    skills
FROM top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY top_paying_jobs.salary_year_avg DESC

/*
🔝 Top Skills:
SQL – Most frequently required; foundational for data querying.

Python – Dominant for data manipulation, analysis, and automation.

R – Often preferred in statistical and research-heavy roles.

Azure – Strong demand for cloud-based analytics experience.

Databricks – Indicates shift towards big data & collaborative platforms.

Power BI – Popular for business-focused dashboarding.

Snowflake – Reflects trend toward modern cloud data warehousing.

AWS – Cloud skills continue to be vital for data roles.

Tableau – Still a major visualization tool in demand.

Spark – Required for processing large-scale data. */