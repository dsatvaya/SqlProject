# 📊 Introduction

This repository contains a collection of SQL queries aimed at analyzing the job market for **Data Analyst** roles in India. The analysis is based on job postings data and provides actionable insights into:

- 🔝 Top 10 highest paying Data Analyst jobs in India  
- 💼 Most in-demand and top-paying skills  
- 💡 Optimal skills based on a balance of demand and salary

🔍 Sql queries? Check them out here: [adv_sql folder](/adv_sql/)

# 🧠 BackGround

Breaking into the Data Analyst field in India can be challenging due to:

- Unclear demand for specific skills  
- Limited visibility into salary trends  
- Difficulty identifying high-impact skills  

This project uses SQL to analyze job posting data, aiming to:

- Highlight top-paying Data Analyst roles  
- Identify the most in-demand and high-paying skills  
- Provide data-driven insights for career planning


# Tools used
To conduct the analysis and manage this project effectively, the following tools were used:

- **SQL** was used to query and analyze job market data, helping extract meaningful insights from large datasets.

- **PostgreSQL** served as the database system for executing complex joins, aggregations, and subqueries.

- **Visual Studio Code (VS Code)** was the primary code editor used for writing and managing SQL scripts efficiently.

- **Git & GitHub** were used for version control and project collaboration, ensuring smooth tracking of changes and easy sharing.

# The Analysis

## To better understand the Data Analyst job landscape in India, we began by identifying the **top 10 highest-paying job listings**. 

- Code used:

```sql
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_location,
    name,
    job_schedule_type,
    job_posted_date :: DATE,
    salary_year_avg
FROM
    job_postings_fact
left JOIN company_dim ON 
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_country = 'India'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

## In the second stage we find **the skills associated with these high paying jobs**

- code used:
```sql
WITH top_10_jobs AS (
SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_location,
    name,
    job_schedule_type,
    salary_year_avg
FROM
    job_postings_fact
left JOIN company_dim ON 
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_country = 'India'
ORDER BY
    salary_year_avg DESC
LIMIT 10
)


SELECT 
    top_10_jobs.*,
    skills_dim.skills
FROM top_10_jobs
INNER JOIN
    skills_job_dim on top_10_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
order BY salary_year_avg DESC
```
### 🔍 Key Insights:

![Skills Associated with top-paying jobs](images\skills_associated_with_top_paying_jobs.png)

- SQL and Excel appear most often, confirming their foundational importance in high-paying roles.

- Visualization tools like Tableau and Power BI are also prominently featured, reflecting demand for professionals who can present data clearly.

- Presentation skills such as proficiency in PowerPoint are valued, likely for reporting insights to stakeholders.

- Tools like Python and R (if present) would also indicate analytical and programming capabilities—watch for them in more advanced roles.


# What I learned
# Conclusion
