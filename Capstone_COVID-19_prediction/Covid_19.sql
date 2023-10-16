/*
1. Find the number of corona patients who faced shortness of breath.
*/
select count(*) 
from covid_19 
where shortness_of_breath = '1';

/*
2. Find the number of negative corona patients who have fever and sore_throat.
*/
select count(*) 
from covid_19
where Corona = '0'
and fever = '0'
and Sore_throat = '0';

/*
3. Group the data by month and rank the number of positive cases.
*/
select 
DATE_FORMAT(Test_date, '%Y-%m') AS Month,
count(Corona) as PositiveCases,
rank() over (order by count(Corona) desc) as Rank1
from covid_19
where Corona='1'
group by Month
order by PositiveCases desc;

/*
4. Find the female negative corona patients who faced cough and headache.
*/
select count(*) 
from covid_19
where Corona = '0'
and sex = '0'
and Cough_symptoms = '1'
and Headache = '1';

/*
5. How many elderly corona patients have faced breathing problems?
*/
select count(*) 
from covid_19
where Corona = '1'
and Age_60_Above = 'yes'
and Shortness_of_breath = '1';

/*
6. Which three symptoms were more common among COVID positive patients?
*/
with covid_positive_CTE as (
	select * from covid_19 
    where Corona  = '1'
)
SELECT 'Cough_symptoms' AS Symptom, count(Cough_symptoms) AS Symptom_Count
FROM covid_positive_CTE
WHERE Cough_symptoms = '1'
	UNION
SELECT 'Fever' AS Symptom, count(Fever) AS Symptom_Count
FROM covid_positive_CTE
WHERE Fever = '1'
	UNION
SELECT 'Sore_throat' AS Symptom, count(Sore_throat) AS Symptom_Count
FROM covid_positive_CTE
WHERE Sore_throat = '1'
	UNION
SELECT 'Shortness_of_breath' AS Symptom, count(Shortness_of_breath) AS Symptom_Count
FROM covid_positive_CTE
WHERE Shortness_of_breath = '1'
	UNION
SELECT 'Headache' AS Symptom, count(Headache) AS Symptom_Count
FROM covid_positive_CTE
WHERE Headache = '1'
ORDER BY Symptom_Count DESC
LIMIT 3;

/*
7. Which symptom was less common among COVID negative people?
*/
with covid_negative_CTE as (
	select * from covid_19 
    where Corona  = '0'
)
SELECT 'Cough_symptoms' AS Symptom, count(Cough_symptoms) AS Symptom_Count
FROM covid_negative_CTE
WHERE Cough_symptoms = '1'
	UNION
SELECT 'Fever' AS Symptom, count(Fever) AS Symptom_Count
FROM covid_negative_CTE
WHERE Fever = '1'
	UNION
SELECT 'Sore_throat' AS Symptom, count(Sore_throat) AS Symptom_Count
FROM covid_negative_CTE
WHERE Sore_throat = '1'
	UNION
SELECT 'Shortness_of_breath' AS Symptom, count(Shortness_of_breath) AS Symptom_Count
FROM covid_negative_CTE
WHERE Shortness_of_breath = '1'
	UNION
SELECT 'Headache' AS Symptom, count(Headache) AS Symptom_Count
FROM covid_negative_CTE
WHERE Headache = '1'
ORDER BY Symptom_Count ASC
LIMIT 1;

/*
8. What are the most common symptoms among COVID positive males whose known contact was abroad? 
*/
with covid_positive_males_CTE as (
	select * from covid_19 
    where Corona  = '1'
		and sex = '1'
		and Known_contact = '0'
)
SELECT 'Cough_symptoms' AS Symptom, count(Cough_symptoms) AS Symptom_Count
FROM covid_positive_males_CTE
WHERE Cough_symptoms = '1'
	UNION
SELECT 'Fever' AS Symptom, count(Fever) AS Symptom_Count
FROM covid_positive_males_CTE
WHERE Fever = '1'
	UNION
SELECT 'Sore_throat' AS Symptom, count(Sore_throat) AS Symptom_Count
FROM covid_positive_males_CTE
WHERE Sore_throat = '1'
	UNION
SELECT 'Shortness_of_breath' AS Symptom, count(Shortness_of_breath) AS Symptom_Count
FROM covid_positive_males_CTE
WHERE Shortness_of_breath = '1'
	UNION
SELECT 'Headache' AS Symptom, count(Headache) AS Symptom_Count
FROM covid_positive_males_CTE
WHERE Headache = '1'
ORDER BY Symptom_Count DESC
LIMIT 3;






