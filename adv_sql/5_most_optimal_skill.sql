/* 
    This query is used to find the most optimal skills for Data Analyst in India
    based on average salary and demand.
*/



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




/* shortend version of the query */
-- most optimal skills for Data Analyst in India

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