-- Case Study 2: Investigating Metric Spike

#create table- users

create table users ( 
user_id int,
created_at datetime,
company_id int,
language varchar(100),
activated_at datetime,
state varchar(100)
);

desc users;

select * from users;


#create table- events

create table events ( 
user_id int,
occurred_at datetime,
event_type varchar(100),
event_name varchar(100),
location varchar(100),
device varchar(100),
user_type int
);

#create table- email_events

create table email_events ( 
user_id int,
occurred_at datetime,
action varchar(100),
user_type int
);

desc users;
desc events;
desc email_events;

show variables like 'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;


select * from users;
select count(*) from users;


load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

desc events;
select * from events;
select count(*) from events;


load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from email_events;
select count(*) from email_events;


-- Task-A: Write an SQL query to calculate the weekly user engagement.

select extract(week from occurred_at) as week_number,
count(distinct user_id) as active_user
from events
where event_type='engagement'
group by week_number
order by week_number;

-- Task-B: Write an SQL query to calculate the user growth for the product.

select week_num, Year_num, active_users, 
sum(active_users) over(order by year_num, week_num rows between unbounded preceding and current row) as cumulative_sum
from
(
select extract(week from activated_at) as week_num,
extract(year from activated_at) as year_num,
count(distinct user_id) as active_users from users
where state='active'
Group by year_num, week_num
order by year_num, week_num
)a




-- Task-C: Write an SQL query to calculate the weekly retention of users based on their sign-up cohort.
WITH cohorts AS (
    SELECT
        DATE(activated_at) AS cohort_start_date,
        COUNT(*) AS total_users
    FROM users
    GROUP BY 1
),
weekly_stats AS (
    SELECT
        DATE(u.activated_at) AS cohort_start_date,
        YEARWEEK(e.occurred_at, 0) AS year_week,
        COUNT(DISTINCT e.user_id) AS active_users
    FROM users u
    JOIN events e ON u.user_id = e.user_id
    WHERE e.event_type = 'engagement'
    GROUP BY cohort_start_date, year_week
)
SELECT
    cohorts.cohort_start_date,
    weekly_stats.year_week,
    weekly_stats.active_users,
    cohorts.total_users AS total_users,
    weekly_stats.active_users / cohorts.total_users * 100 AS retention_rate
FROM cohorts
JOIN weekly_stats
    ON cohorts.cohort_start_date = weekly_stats.cohort_start_date
ORDER BY cohort_start_date, year_week;


-- Task-D: Write an SQL query to calculate the weekly engagement per device
select * from events;

with cte as (select extract(week from occurred_at) as week_num,
device, count(distinct user_id) as user_count
from events
where event_type ='engagement'
group by week_num, device
order by week_num)
select week_num, device, user_count
from cte;

-- Task-E: Write an SQL query to calculate the email engagement metrics.

select action, extract(month  from  occurred_at)  as  month, count(action) as number_of_mails  
from email_events 
group by action, month 
order by action, month;





