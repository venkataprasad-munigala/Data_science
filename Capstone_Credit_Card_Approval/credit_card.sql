SELECT @@sql_mode;
SET @@sql_mode = SYS.LIST_DROP(@@sql_mode, 'ONLY_FULL_GROUP_BY');

/*
1. Group the customers based on their income type and find the average of their annual income.
*/
select Income_Type, avg(Income) as AVG_Income
from credit_card
group by Income_Type
order by Income_Type;
             
-- 0: Commercial associate    
-- 1: Pensioner               
-- 2: State servant 
-- 3: Working              

/*
2. Find the female owners of cars and property.
*/
select ID
from credit_card
where Gender = '0'
and Car_Owner = '1'
and Prop_Owner = '1';

/*
3. Find the male customers who are staying with their families.
*/
select ID
from credit_card
where Gender = '1'
and Housing_Type = '5';

-- 0: Co-op apartment 
-- 1: House / apartment      
-- 2: Municipal apartment     
-- 3: Office apartment
-- 4: Rented apartment        
-- 5: With parents

/*
4. Please list the top five people having the highest income.
*/
select ID, Income
from credit_card
order by Income desc
limit 5;

/*
5. How many married people are having bad credit?
*/
select 'Bad Credit', count(*)
from credit_card
where Marital_Status = '1'
and label = '1';

/*
6. What is the highest education level and what is the total count?
*/
select Education, count(*) as Count
from credit_card
where Education = '1';

-- 0: Academic degree
-- 1: Higher education
-- 2: Incomplete higher
-- 3: Lower secondary
-- 4: Secondary / secondary special

/*
7. Between married males and females, who is having more bad credit?
*/
select Gender, count(*) as count
from credit_card
where label = 1
group by Gender
order by count desc;

-- 0: Female
-- 1: Male


