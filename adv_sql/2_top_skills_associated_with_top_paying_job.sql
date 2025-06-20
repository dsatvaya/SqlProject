


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
