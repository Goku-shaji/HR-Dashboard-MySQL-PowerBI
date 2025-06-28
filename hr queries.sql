create database projects;
USE PROJECTS;
select*from hr;
# data cleaning
alter table hr
change column ï»¿id  emp_id varchar(20) null;
desc hr;
-- updating birthdate
update hr 
SET BIRTHDATE= CASE
when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;
-- changinng data type of column
alter table hr modify column birthdate date;
desc hr;
select birthdate from hr;
-- hire date
select hire_Date from hr;
update hr
set hire_date= case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
 end;
 alter table hr modify column hire_Date date;
 -- cleaning termdate
 select termdate from hr;
 update hr
 SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;
desc hr;
-- adding age column
select * from hr;
alter table hr add column age int after birthdate;
update hr set age=timestampdiff(Year,birthdate,curdate());
select birthdate,age from hr;

-- Questions
-- 1. What is the gender breakdown of employees in the company?
select gender ,count(*) as count from hr where age>=18 and termdate='0000-00-00'group by gender;
-- 2. what is the race/ethnicity breakdown of employees in the company?
select race, count(*) count from hr where age>=18 and termdate='0000-00-00' group by race order by count desc;
-- Q3. What is the age distribution of the company?
select
min(Age) as Youngest,
max(age) as Eldest from hr where age>=18 and termdate='0000-00-00';
select* from hr;
select count(termdate) from hr;
select 
case 
when age>=18 and age<=24 then '18-24'
when age>=25 and age<=34 then '25-34'
when age>=35 and age<=44 then  '35-44'
when age>=45 and age<=54 then '45-54'
when age>=55 and age<=64 then '55-64'
else '65+'
end as age_group, gender,
count(*) as count from hr  where age>=18 and termdate='0000-00-00' group by age_group, gender order by age_group, gender;	

select count(*) from hr;
-- q4. How many  employees work at headquarters versus remote locations?
select location, count(*) as count  from hr 
where age>=18 and termdate='0000-00-00' group by location;
-- Q5. What is the average length of employment for employees who have been terminated?
select 
round(avg(datediff(termdate, hire_Date))/365,0) as  avg_length_employment 
from hr where termdate <= curdate() and termdate<> '0000-00-00' and age>=18;
-- Q6. How does gender distribution vary across departments and job title?
select department, gender, count(*) as count from hr 
where age>=18 and termdate='0000-00-00' group by department, gender
order by department;
-- q7. What is the distribution of job titles across the company?
select jobtitle, count(*) as count from hr
where age>=18 and termdate='0000-00-00'
group by  jobtitle order by jobtitle desc;
-- q8. Which department has the highest tunrover rate?
select department, total_count, terminated_count, terminated_count/total_count as termination_rate
from ( select department, count(*) as total_count, sum(case when termdate <> '0000-00-00' and termdate <=curdate() then 1 else 0 end) as terminated_count from hr
where age>=18 group by department) 
as subqquery order by  termination_rate desc;
-- q9 what is the distribution of employees across the locations by city and state?
select location_state, count(*) as count from hr
where age>=18 and termdate='0000-00-00' group by location_state order by  count desc; 
-- q10. How has the company's employee  count changed over time based on  hire and term dates?
select
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires *100,2) as  net_change_percent
from ( select year(hire_Date) as  year,
		count(*) as hires,
		sum(Case when  termdate <> '0000-00-00' and termdate <=curdate() then 1 else 0 end) as terminations
        from  hr where  age>=18 group by year(hire_Date)) as subquery 
order by  year asc;

-- q11. what is the tenure distribution for each department?
select department,round(avg(datediff(termdate, hire_date)/365),0) as  avg_tenure 
from  hr  where termdate <= curdate() and  termdate <> '0000-00-00' and age>=18 group by department;
