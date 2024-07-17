-- Operation Analytics and Investigating Metric Spike 

-- Case Study 1: Job Data Analysis

show databases;
use project3;
create table job_data (ds date, job_id int not null, 
actor_id int not null,
event varchar(15) not null,
language varchar(15) not null,
time_spent int not null,
org char(2));
select * from job_data;
desc job_data;

-- insert data into job_data table
 
INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org) 
VALUES ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');

select * from job_data;

-- Task-A. Calculate the number of jobs reviewed per hour per day for November 2020? 

SELECT ds, SUM(time_spent)/COUNT(*) AS avg_time_spent 
FROM job_data 
WHERE ds BETWEEN '2020-11-01' AND '2020-11-30' 
GROUP BY ds 
ORDER BY ds;


-- Task-B: Let’s say the above metric is called throughput. Calculate 7 day rolling average of throughput? For throughput, do you prefer daily metric or 7-day rolling and why? 

SELECT ds, event_per_day, AVG(event_per_day) OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND  CURRENT ROW) AS 7_day_rolling_avg 
FROM (SELECT ds, COUNT(DISTINCT event) AS event_per_day 
FROM job_data 
WHERE ds BETWEEN '2020-11-01' and '2020-11-30'
GROUP BY ds  
ORDER BY ds)a;


-- Task-C: Calculate the percentage share of each language in the last 30 days? 


select language, round(((count(language)/8)*100),2) as share_of_lang 
from job_data group by language;


-- Task-D: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table? 
select * from job_data;

SELECT * FROM job_data WHERE job_id IN (SELECT job_id FROM job_data GROUP BY job_id HAVING COUNT(*) > 1) ;




