/*

most in demand skills
*/

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