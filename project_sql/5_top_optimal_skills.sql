WITH skills_demand AS (
    SELECT 
        sd.skill_id,
        sd.skills AS skill,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
    WHERE 
        jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id, sd.skills
),
average_salary AS (
    SELECT 
        sd.skill_id,
        sd.skills,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON sjd.job_id = jpf.job_id
    INNER JOIN skills_dim sd ON sd.skill_id = sjd.skill_id
    WHERE 
        jpf.job_title_short = 'Data Analyst'
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sd.skill_id, sd.skills
)

SELECT 
    sd.skill_id,
    sd.skill,
    sd.demand_count,
    asal.avg_salary
FROM skills_demand sd
INNER JOIN average_salary asal ON sd.skill_id = asal.skill_id
WHERE   sd.demand_count > 10
ORDER BY asal.avg_salary DESC,sd.demand_count DESC;
