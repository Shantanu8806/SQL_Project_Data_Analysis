
# Data Analyst Job Market SQL Project

## 📊 Introduction

Dive into the data job market! Focusing on data analyst roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries? Check them out here: [project_sql folder](/project_sql/)

## 🔍 Background

Driven by a quest to navigate the data analyst job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others' work to find optimal jobs.

Data hails from Luke Barousse's [SQL Course](https://lukebarousse.com/sql). It's packed with insights on job titles, salaries, locations, and essential skills.

### The Questions Explored:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

## ⚙️ Tools Used
- **SQL** for querying and insights
- **PostgreSQL** as the database
- **Visual Studio Code** for development
- **Git & GitHub** for version control and collaboration

## 📈 The Analysis

### 1. Top Paying Data Analyst Jobs
```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst'
  AND job_location = 'Anywhere'
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```

![Top Paying Roles](assets/1_top_paying_roles.png)

### 2. Skills for Top Paying Jobs
```sql
WITH top_paying_jobs AS (
    SELECT job_id, job_title, salary_year_avg, name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
      AND job_location = 'Anywhere'
      AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_jobs.*, skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```

![Top Paying Skills](assets/2_top_paying_roles_skills.png)

### 3. In-Demand Skills for Data Analysts
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

## 🐍 Python-Focused Analysis

### Python Salary Insights
```sql
WITH top_python_jobs AS (
    SELECT jpf.job_id, jpf.salary_year_avg
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    WHERE sd.skills ILIKE 'Python'
      AND jpf.salary_year_avg IS NOT NULL
    ORDER BY jpf.salary_year_avg DESC
    LIMIT 10
)
SELECT * FROM top_python_jobs;
```

### Python Chart Generation (Bar Plot)
```python
import pandas as pd
import matplotlib.pyplot as plt

# Sample Data
data = {
    'job_id': ['101', '102', '103', '104', '105'],
    'salary_year_avg': [160000, 158000, 155000, 153000, 150000]
}

df = pd.DataFrame(data)

# Plot
plt.figure(figsize=(10,6))
plt.bar(df['job_id'], df['salary_year_avg'], color='skyblue')
plt.title('Top Paying Jobs That Require Python')
plt.xlabel('Job ID')
plt.ylabel('Average Salary (USD)')
plt.tight_layout()
plt.savefig('assets/python_top_jobs_chart.png')
plt.show()
```

![Python Salary Chart](assets/python_top_jobs_chart.png)

### 4. Skills Based on Salary
```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

### 5. Most Optimal Skills to Learn
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 10
ORDER BY avg_salary DESC, demand_count DESC
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |

## 📚 What I Learned

- 🧩 Crafting complex SQL with CTEs and JOINs
- 📊 Aggregating and transforming data using GROUP BY, COUNT(), and AVG()
- 💡 Deriving actionable insights to support real-world career planning

## ✅ Conclusions

1. Remote data analyst jobs can pay up to $650K/year.
2. SQL is the top in-demand and high-paying skill.
3. Python, Tableau, and Excel are essential complements.
4. Learning cloud and data engineering tools boosts salary potential.
5. Skill selection should balance demand and average salary impact.

## 🚀 Final Thoughts

This project leveled up my SQL skills and delivered actionable market insights. If you're a data analyst or aspiring one, use this guide to prioritize what to learn next!

