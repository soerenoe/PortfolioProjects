--Basic overview--

--See everything
Select * --Selects everything (*) 
From PortfolioProjects..[HRDataset] --From the table (..[]) in the database
order by 2 --Orders by the column of interest
--Comment out [selection] with Ctrl+K, then Ctrl+C
--Comment out [selection] with Ctrl+K, then Ctrl+U

--Filter specific columns of interest
Select State, Department, EmpSatisfaction --Select the columns of interest
From PortfolioProjects..HRDataset --From the table in the database
Order by 2 --Order by the ordered column of interest

  
--Exploring HR metrics--

--Looking at the biggest recruitment channels - cost/benefit
SELECT RecruitmentSource, COUNT(*) AS count --Counting the most commmon
From PortfolioProjects..[HRDataset]
GROUP BY RecruitmentSource
ORDER BY count DESC
  
--Looking at turnover rate (counting non-nulls and calculating non_null_Hired/non_null_Terminated)
WITH DateCounts AS (
    SELECT 
        SUM(CASE WHEN DateofHire IS NULL THEN 1 ELSE 0 END) AS hire_nulls, --Summarize cases when DateofHire is and isn't NULL
        COUNT(DateofHire) AS hire_not_nulls, --Count the non-NULLS to enable a calculation of a rate
        SUM(CASE WHEN DateofTermination IS NULL THEN 1 ELSE 0 END) AS termination_nulls, --Do the same thing with DateofTermination
        COUNT(DateofTermination) AS termination_not_nulls
    FROM PortfolioProjects..[HRDataset])
    SELECT 
        hire_not_nulls AS hire_not_nulls_count,
        termination_not_nulls AS termination_not_nulls_count,
        CAST(termination_not_nulls AS float) / NULLIF(hire_not_nulls, 0) AS turnover_rate
    FROM DateCounts;

--Looking at the most common reasons for quitting - special interest in areas that the company can do something about
SELECT TermReason, COUNT(*) AS count
From PortfolioProjects..[HRDataset]
WHERE EmploymentStatus = 'Voluntarily Terminated'
GROUP BY TermReason
ORDER BY count DESC

  
--Equality areas--
  
--Looking at salary difference between men and women in the same position - equality efforts
SELECT position,
       AVG(CASE WHEN sex = 'M' THEN salary END) AS avg_male_salary, --Calculate the average of cases when sex = 'M'
       AVG(CASE WHEN sex = 'F' THEN salary END) AS avg_female_salary,
       AVG(CASE WHEN sex = 'M' THEN salary END) - AVG(CASE WHEN sex = 'F' THEN salary END) AS salary_difference
FROM PortfolioProjects..[HRDataset]
GROUP BY position
ORDER BY salary_difference DESC;

--Looking at salary difference between the two most common ethnicities in the company - equality efforts
SELECT position,
       AVG(CASE WHEN RaceDesc = 'White' THEN salary END) AS avg_white_salary,
       AVG(CASE WHEN RaceDesc = 'Black or African American' THEN salary END) AS avg_black_salary,
       AVG(CASE WHEN RaceDesc = 'White' THEN salary END) - AVG(CASE WHEN RaceDesc = 'Black or African American' THEN salary END) AS salary_difference_white_black
FROM PortfolioProjects..[HRDataset]
GROUP BY position
ORDER BY salary_difference_white_black DESC;
