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