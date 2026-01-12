-- Data cleaning 

SELECT * 
FROM messy_business_dataset ;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null Values or blank values
-- 4. Remove Any Columns

-- first create exact similar table with easy name and then insert the same values as before.
-- It help us, if we messed up with this new table still we can have main table to work with.

CREATE TABLE business 
LIKE messy_business_dataset ;

insert business
select * 
from messy_business_dataset ;

select * 
from business;

-- Now we are looking for duplicates in our datsets to remove them all

select *,
row_number() over(
partition by Customer_ID, Age, Gender, Annual_Income, Spending_Score, Subscription_Type, Region, Churn) as row_num
from business;

with duplicate_cte as
(
select * ,
row_number() over(
partition by Customer_ID, Age, Gender, Annual_Income, Spending_Score, Subscription_Type, Region, Churn) as row_num
from business
)
select * 
from duplicate_cte
where row_num >1;

-- HERE WE CHECK ONE OF THE VALUES FROM CUSTOMER_ID TO SEE IF IT`S REALLY ARE DUPLICATES.

select * 
from business
where Customer_ID = 'CUST1385' ;

-- CREATE NEW TABLE TO ADD A NEW COLUMN IN OUR DATASET WE ARE GOIG TO USE "TABLE STATEMENT" AND ADD NEW TABLE AS "row_num".
-- STEP--> RIGHT CLICK ON YOUR TABLE--> CLICK 'COPY TO CLIPBOARD'--> CLICK 'CREATE STATEMENT'

CREATE TABLE `business2` (
  `Customer_ID` text,
  `Age` text,
  `Gender` text,
  `Annual_Income` text,
  `Spending_Score` text,
  `Subscription_Type` text,
  `Region` text,
  `Churn` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from business2 ;


-- we created a new table with new column and insert all the values as it is.


insert into business2
select * ,
row_number() over(
partition by Customer_ID, Age, Gender, Annual_Income, Spending_Score, Subscription_Type, Region, Churn) as row_num
from business;

select *
from business2
where row_num > 1;

-- now we re going to DELETE values from row_num column which are >1, which are also duplicates.

delete 
from business2
where row_num > 1;

select *
from business2;

-- Standardizing data 
-- now we are going to make every value from table to standardize format.

select distinct Gender
from business2 ;

UPDATE business2
SET Gender = CASE
WHEN Gender LIKE 'F%' THEN 'Female'
WHEN Gender LIKE 'M%' THEN 'Male'
ELSE Gender
END;


select distinct Churn
from business2 ;

Update business2
set Churn = case
when Churn like 'Y%' then 'Yes'
when Churn like 'N%' then 'No'
else Churn
end;

select *
from business2;

-- Now we dont need a 'row_num' column , so we can delete it 

alter table business2
drop column row_num ;

update business2
set Annual_Income = ''
where Annual_Income like 'Unknown' ;


-- here we converted Unkown values Annual Income column into NULL values , where we can fill with Median values of Income.

select Annual_Income
from business2;

select distinct Gender
from business2;

-- convrted NULL values into Unknown in Gender column.
update business2
set Gender = ''
where Gender like 'Unknown' ;

SELECT
SUM(Customer_ID like '') AS customer_id_nulls
FROM business2;

-- Removing Null or Blank '' values because we Cannot identify customer.

  
DELETE FROM business2
WHERE Customer_ID like '';

select distinct Customer_ID
from business2;

SELECT *
FROM business2
WHERE Gender like ''
AND Customer_ID IN (
    SELECT Customer_ID
    FROM business2
    WHERE Gender like ''
);

-- Always remember to convert blanks values into NULL in SQL works.


SELECT
SUM(Gender = '') AS gender_blanks,
SUM(Age = '') AS age_blanks,
SUM(Annual_Income = '') AS income_blanks,
SUM(Spending_Score = '') AS spending_blanks,
SUM(Subscription_Type = '') AS subscription_blanks,
SUM(Region = '') AS region_blanks,
SUM(Churn = '') AS churn_blanks
FROM business2;



UPDATE business2 SET Gender = NULL WHERE Gender = '';
UPDATE business2 SET Age = NULL WHERE Age = '';
UPDATE business2 SET Annual_Income = NULL WHERE Annual_Income = '';
UPDATE business2 SET Spending_Score = NULL WHERE Spending_Score = '';
UPDATE business2 SET Subscription_Type = NULL WHERE Subscription_Type = '';
UPDATE business2 SET Region = NULL WHERE Region = '';
UPDATE business2 SET Churn = NULL WHERE Churn = '';


UPDATE business2 b1
JOIN business2 b2
  ON b1.Customer_ID = b2.Customer_ID
 AND b2.Gender IS NOT NULL
SET b1.Gender = b2.Gender
WHERE b1.Gender IS NULL;

update business2
set Gender = 'Unknown'
where Gender like '' ;

UPDATE business2
SET Subscription_Type = 'Unknown'
WHERE Subscription_Type IS NULL;

select * from business2;

SELECT COUNT(*) 
FROM business2
WHERE Age = '' ;


-- To get median we must clean all data in Age column , like removing dirty values such as 'N/A' , and NULL/BLANK values.
 
UPDATE business2
SET Age = NULL
WHERE Age = '';

UPDATE business2
SET Age = NULL
WHERE Age = 'N/A';


SELECT 
    COUNT(*) AS null_ages
FROM business2
WHERE Age IS NULL;

SELECT DISTINCT Age
FROM business2
WHERE Age IS NOT NULL;

-- Now we used the AVG and Median to feel NULL values. for learning it is safe to fill NULL values with Median Values, But i the sensitive data like Healthcare,Banking oray offficial company data
-- we must keep NULL as it is. 

UPDATE business2
JOIN (
    SELECT ROUND(AVG(CAST(Age AS UNSIGNED))) AS avg_age
    FROM business2
    WHERE Age IS NOT NULL
) t
SET business2.Age = t.avg_age
WHERE business2.Age IS NULL;

UPDATE business2
SET Region = NULL
WHERE Region = '';

select * from business2;

UPDATE business2
SET Churn = NULL
WHERE Churn = '';

SELECT COUNT(*) FROM business2;

-- this checks if there any NULL,BLANKS OR Dirty values are present.
UPDATE business2
SET Annual_Income = NULL
WHERE Annual_Income IN ('', 'Unknown', 'N/A');


UPDATE business2
JOIN (
    SELECT ROUND(AVG(CAST(Annual_Income AS UNSIGNED))) AS avg_income
    FROM business2
    WHERE Annual_Income IS NOT NULL
) t
SET business2.Annual_Income = t.avg_income
WHERE business2.Annual_Income IS NULL;

-- Data types are still TEXT format

SELECT *
FROM business2
WHERE Age REGEXP '[^0-9]'
   OR Annual_Income REGEXP '[^0-9]'
   OR Spending_Score REGEXP '[^0-9]';

ALTER TABLE business2 
MODIFY Age INT, 
MODIFY Annual_Income INT;

SELECT DISTINCT Spending_Score
FROM business2
ORDER BY Spending_Score;

-- we reeplace Text values in NULL values Spending Score must be in INT form.  
UPDATE business2
SET Spending_Score = NULL
WHERE Spending_Score REGEXP '[^0-9]';

-- If a column is conceptually numeric, text values are data errors — not categories.

select spending_score
from business2;

ALter table business2
modify Spending_Score INT;

-- IT show thw NULL,Data Types,Key,Default etc of the table. 
DESCRIBE business2;

UPDATE business2
SET Region = 'Unknown'
WHERE Region IS NULL;

UPDATE business2
SET Subscription_Type = 'Unknown'
WHERE Subscription_Type IS NULL;

-- lets check if there is any NULL values are present in entire table. 
SELECT
    SUM(Customer_ID IS NULL) AS customer_id_nulls,
    SUM(Age IS NULL) AS age_nulls,
    SUM(Gender IS NULL) AS gender_nulls,
    SUM(Annual_Income IS NULL) AS income_nulls,
    SUM(Spending_Score IS NULL) AS spending_nulls,
    SUM(Subscription_Type IS NULL) AS subscription_nulls,
    SUM(Region IS NULL) AS region_nulls,
    SUM(Churn IS NULL) AS churn_nulls
FROM business2;

-- Sanity checks , like finding MIN, MAX values . 
SELECT MIN(Age), MAX(Age) FROM business2;

SELECT MIN(Annual_Income), MAX(Annual_Income) FROM business2;

SELECT MIN(Spending_Score), MAX(Spending_Score) FROM business2;

select *
from business2;





