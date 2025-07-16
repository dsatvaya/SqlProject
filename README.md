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

## Top 10 highest-paying job listings 

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

## The skills associated with these high paying jobs

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
Skills Associated with top-paying jobs 
![Skills Associated with top-paying jobs](images\skills_associated_with_top_paying_jobs.png)

- SQL and Excel appear most often, confirming their foundational importance in high-paying roles.

- Visualization tools like Tableau and Power BI are also prominently featured, reflecting demand for professionals who can present data clearly.

- Presentation skills such as proficiency in PowerPoint are valued, likely for reporting insights to stakeholders.

- Tools like Python and R (if present) would also indicate analytical and programming capabilities—watch for them in more advanced roles.

## Most In-Demand Skills
### 📊 Top 5 Most In-Demand Data Skills

| Skill | Job Count |
| :--- | ---: |
| **SQL** | 3,167 |
| **Python** | 2,207 |
| **Excel** | 2,118 |
| **Tableau** | 1,673 |
| **Power BI** | 1,285 |

- code used:
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type,
    COUNT(job_postings_fact.*) AS job_count
FROM skills_dim
INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
      job_country = 'India'
GROUP BY skills_dim.skill_id, skills_dim.skills
ORDER BY job_count DESC
LIMIT 25;
```
### 🔍 Key Insights:

- **SQL is the most critical skill by a significant margin**, establishing it as the absolute foundation for data roles. It is closely followed by the powerful combination of a programming language, Python, and the ubiquitous analysis tool, Excel, which together form the core toolkit for analysts.

- **Data visualization is a top priority for employers**, with BI tools like Tableau and Power BI ranking 4th and 5th respectively. This shows that the ability to create clear, interactive dashboards to communicate findings is just as important as the analysis itself.

- **Cloud computing skills are increasingly essential**, with platforms like Azure, AWS, and Snowflake featuring prominently. This reflects a major industry trend of migrating data infrastructure and analytics workflows to the cloud.

## Top Skills By salary
### 💰 Top 5 Highest-Paying Skills

| Skill | Average Salary (USD) |
| :--- | ---: |
| **PostgreSQL** | $165,000 |
| **MySQL** | $165,000 |
| **Linux** | $165,000 |
| **GitLab** | $165,000 |
| **PySpark** | $165,000 |

- code used
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS AVG_SALARY
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id

WHERE 
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_country = 'India'
GROUP BY skills_dim.skill_id, skills_dim.skills
ORDER BY AVG_SALARY DESC
LIMIT 50;
```
### 🔍 Key Insights:
The highest salaries are commanded not by traditional analyst tools, but by advanced technical skills in **data engineering, database administration (PostgreSQL, MySQL), and DevOps (Linux, GitLab)**, indicating that roles that build and maintain data infrastructure pay a premium.

Expertise in **big data and data pipeline technologies** is extremely lucrative. Skills like **PySpark, Airflow, Kafka**, and **Databricks** are among the top earners, highlighting the value placed on managing large-scale, complex data flows.

There is a clear difference between the most in-demand skills and the highest-earning ones; widely used tools like **Power BI** and **Azure** have a lower salary ceiling compared to the more specialized, high-paying technical skills.

## Most Optimal Skills

- code used
```sql
WITH skills_bySalary AS(
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS AVG_SALARY
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id

    WHERE 
        job_postings_fact.salary_year_avg IS NOT NULL AND
        job_postings_fact.job_title_short = 'Data Analyst' AND
        job_country = 'India'
    GROUP BY skills_dim.skill_id, skills_dim.skills
), skills_byDemand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type,
    COUNT(job_postings_fact.*) AS job_count
    FROM skills_dim
    INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
    WHERE job_postings_fact.job_title_short = 'Data Analyst' AND
        job_country = 'India' AND
        job_postings_fact.salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id, skills_dim.skills
)

SELECT
    skills_bySalary.skill_id,
    skills_bySalary.skills,
    skills_bySalary.AVG_SALARY,
    skills_byDemand.job_count

FROM skills_bySalary
INNER JOIN skills_byDemand ON skills_bySalary.skill_id = skills_byDemand.skill_id

WHERE skills_byDemand.job_count > 10

ORDER BY skills_bySalary.AVG_SALARY DESC,
        skills_byDemand.job_count DESC
```
- Short Version of the upper code
```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type,
    COUNT(job_postings_fact.job_id) AS skills_demand,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS AVG_SALARY
FROM skills_dim
INNER JOIN skills_job_dim ON skills_dim.skill_id = skills_job_dim.skill_id
INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id

WHERE
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.job_title_short = 'Data Analyst' AND
    job_postings_fact.job_country = 'India'

GROUP BY
    skills_dim.skill_id,
    skills_dim.skills

HAVING COUNT(job_postings_fact.job_id) > 10

ORDER BY
    AVG_SALARY DESC,
    skills_demand DESC
```
### 🔍 Key Insights:
Most Optimal Skills:
![Code_Generated_Image.png](images\Code_Generated_Image.png)

- A central trade-off exists between demand and pay: specialized skills like **Spark** command the highest salaries for lower demand, while foundational skills like **SQL and Python** have the highest demand but offer comparatively lower salaries on this list.

- The most balanced or **"optimal"** skills are **Business Intelligence (Power BI, Tableau) and Cloud (Azure)** tools. They represent a strategic sweet spot, offering both high job demand and excellent six-figure salaries.

- Despite the salary differences on this list **SQL**, **Python**, and **Excel** remain the most critical skills to learn. Their massive demand makes them the essential foundation required for almost any job in the data field.


# 🏁 Conclusion

This project successfully navigated the Indian Data Analyst job market, transforming complex job posting data into a clear and actionable career roadmap. The analysis reveals a distinct pathway for aspiring professionals, highlighting the journey from foundational requirements to high-earning specializations.

The key takeaway is a two-tiered skill structure:
1.  **The Foundation:** Skills like **SQL, Python, and Excel** are non-negotiable. Their overwhelming demand makes them the essential toolkit for breaking into the field and securing a first role.
2.  **The Specialization:** True earning potential is unlocked through specialization. Advanced skills in **data engineering (PySpark, PostgreSQL)**, **DevOps (GitLab)**, and **cloud platforms** command the highest salaries, rewarding deep technical expertise.

For those seeking the most strategic path forward, the data points clearly to **Business Intelligence (Power BI, Tableau)** and **Cloud (Azure)** tools. These skills represent the optimal sweet spot, offering a powerful combination of high demand and competitive salaries.

In summary, the most effective strategy for an aspiring Data Analyst in India is to build a rock-solid foundation in the basics and then strategically specialize in high-growth, high-value areas. This data-driven approach ensures that your learning journey aligns directly with what the market truly values, paving the way for a successful and lucrative career.
