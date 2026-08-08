SELECT *
FROM analytics
LIMIT 10;

--See if the data has missing values:
select
    count(*) as total_rows,
    count(student_id) as student_id_not_null,
    count(gender) as gender_not_null,
    count(avg_sleep_hours) as sleep_not_null,
    count(term_gpa) as gpa_not_null
from analytics;

--sleep statistics:
select
    round(avg(avg_sleep_hours),2) as avg_sleep,
    min(avg_sleep_hours) as min_sleep,
    max(avg_sleep_hours) as max_sleep
from analytics;

--gpa by gender:
select
    gender,
    count(*) as students,
    round(avg(term_gpa),2) as avg_gpa
from analytics
group by gender
order by avg_gpa desc;

--sleep categories:
select
    sleep_bracket,
    count(*) as students
from analytics
group by sleep_bracket
order by students desc;

--avg gpa by sleep category:
select
    sleep_bracket,
    round(avg(term_gpa),2) as avg_gpa
from analytics
group by sleep_bracket
order by avg_gpa desc;

--universities with highest gpa:
select
    university,
    round(avg(term_gpa),2) as avg_gpa,
    count(*) as students
from analytics
group by university
having count(*) >= 20
order by avg_gpa desc;

--top 10 students and their avg_sleep_hours
select
    student_id,
    university,
    term_gpa,
    avg_sleep_hours
from analytics
order by term_gpa desc
limit 10;

--ranking students
select
    student_id,
    university,
    term_gpa,
    avg_sleep_hours,
    rank() over (order by term_gpa desc) as gpa_rank
from analytics;

--cte usage example
WITH sleep_stats AS (
    SELECT
        sleep_bracket,
        round(AVG(term_gpa),2) AS avg_gpa
    FROM analytics
    GROUP BY sleep_bracket
)

SELECT *
FROM sleep_stats
ORDER BY avg_gpa DESC;

--sleep category and gpa:
select
    student_id,
    case
        when avg_sleep_hours between 7 and 8 then 'Excellent'
        when avg_sleep_hours between 6 and 7 then 'Good'
        when avg_sleep_hours between 5 and 6 then 'Fair'
        else 'Poor'
    end as sleep_category,
    term_gpa
from analytics;

--sleep category count:
SELECT
    sleep_category,
    COUNT(*) AS category_count
FROM (
    SELECT
        student_id,
        CASE
            WHEN avg_sleep_hours BETWEEN 7 AND 8 THEN 'Excellent'
            WHEN avg_sleep_hours BETWEEN 6 AND 7 THEN 'Good'
            WHEN avg_sleep_hours BETWEEN 5 AND 6 THEN 'Fair'
            ELSE 'Poor'
        END AS sleep_category
    FROM analytics
) AS t
GROUP BY sleep_category
ORDER BY category_count DESC;

--sleep vs gpa
SELECT
    ROUND(avg_sleep_hours) AS sleep_hours,
    ROUND(AVG(term_gpa),2) AS avg_gpa,
    COUNT(*) AS students
FROM analytics
GROUP BY ROUND(avg_sleep_hours)
ORDER BY sleep_hours;

--gender perecentage
SELECT
    gender,
    COUNT(*) AS students,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM analytics
GROUP BY gender;