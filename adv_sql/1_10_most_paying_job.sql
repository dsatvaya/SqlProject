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
-- This query retrieves the top 10 highest paying Data Analyst jobs in India,
-- including job title, location, company name, schedule type, posted date, and average salary.


