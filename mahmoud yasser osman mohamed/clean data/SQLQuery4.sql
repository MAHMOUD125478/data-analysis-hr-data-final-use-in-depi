CREATE DATABASE EmployeeData;
GO
USE EmployeeData;
GO
CREATE TABLE EducationLevel (
    EducationLevelID INT PRIMARY KEY,
    EducationLevel NVARCHAR(100)
);
GO

INSERT INTO EducationLevel (EducationLevelID, EducationLevel) VALUES
(1, 'No Formal Qualifications'),
(2, 'High School'),
(3, 'Bachelors'),
(4, 'Masters'),
(5, 'Doctorate');
GO
CREATE TABLE RatingLevel (
    RatingID INT PRIMARY KEY,
    RatingLevel NVARCHAR(100)
);
GO

INSERT INTO RatingLevel (RatingID, RatingLevel) VALUES
(1, 'Unacceptable'),
(2, 'Needs Improvement'),
(3, 'Meets Expectation'),
(4, 'Exceeds Expectation'),
(5, 'Above and Beyond');
GO
CREATE TABLE SatisfactionLevel (
    SatisfactionID INT PRIMARY KEY,
    SatisfactionLevel NVARCHAR(100)
);
GO

INSERT INTO SatisfactionLevel (SatisfactionID, SatisfactionLevel) VALUES
(1, 'Very Dissatisfied'),
(2, 'Dissatisfied'),
(3, 'Neutral'),
(4, 'Satisfied'),
(5, 'Very Satisfied');
GO
CREATE TABLE Employee (
    EmployeeID NVARCHAR(50) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Gender NVARCHAR(10),
    Age INT,
    BusinessTravel NVARCHAR(50),
    Department NVARCHAR(50),
    DistanceFromHome INT,
    State NVARCHAR(50),
    Ethnicity NVARCHAR(50),
    Education INT,
    EducationField NVARCHAR(50),
    JobRole NVARCHAR(50),
    MaritalStatus NVARCHAR(10),
    Salary DECIMAL(18, 2),
    StockOptionLevel INT,
    OverTime NVARCHAR(10),
    HireDate DATE,
    Attrition NVARCHAR(10),
    YearsAtCompany INT,
    FOREIGN KEY (Education) REFERENCES EducationLevel(EducationLevelID)


);
GO
CREATE TABLE PerformanceRating (
    PerformanceID NVARCHAR(50) PRIMARY KEY,
    EmployeeID NVARCHAR(50),
    ReviewDate DATE,
    EnvironmentSatisfaction INT,
    JobSatisfaction INT,
    RelationshipSatisfaction INT,
    TrainingOpportunitiesWithinYear INT,
    TrainingOpportunitiesTaken INT,
    WorkLifeBalance INT,
    SelfRating INT,
    ManagerRating INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO
--iam now clean data in emplooye
UPDATE Employee
SET Age = 30
WHERE Age IS NULL;
DELETE FROM Employee
WHERE Age IS NULL OR Salary IS NULL;
DELETE FROM Employee
WHERE Age < 18;
UPDATE Employee
SET FirstName = TRIM(FirstName), LastName = TRIM(LastName);

UPDATE Employee
SET Gender = 'Male'
WHERE Gender NOT IN ('Male', 'Female');
ALTER TABLE Employee
ALTER COLUMN HireDate DATE;
UPDATE Employee
SET Salary = (SELECT AVG(Salary) FROM Employee)
WHERE Salary IS NULL;
UPDATE Employee
SET Attrition = 'No'
WHERE Attrition NOT IN ('Yes', 'No');


--iam cleaning data in perforamnce file now

ALTER TABLE PerformanceRating
ALTER COLUMN ReviewDate DATE;



SELECT EmployeeID, ReviewDate, COUNT(*)
FROM PerformanceRating
GROUP BY EmployeeID, ReviewDate
HAVING COUNT(*) > 1;

WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY EmployeeID, ReviewDate ORDER BY PerformanceID) AS RowNum
    FROM PerformanceRating
)
DELETE FROM CTE WHERE RowNum > 1;

--iam now clean SatisfactionLevel

UPDATE  SatisfactionLevel 
SET SatisfactionLevel = TRIM(SatisfactionLevel);


DELETE FROM  SatisfactionLevel 
WHERE  SatisfactionLevel  NOT IN (
    SELECT MIN( SatisfactionLevel )
    FROM  SatisfactionLevel 
    GROUP BY  SatisfactionLevel 
);

--iam nnow clean   EducationLevel  file

UPDATE  EducationLevel 
SET EducationLevel = LTRIM(RTRIM(EducationLevel));

DELETE FROM   EducationLevel 
WHERE EducationLevelID NOT IN (
    SELECT MIN(EducationLevelID)
    
    F

   
FROM   EducationLevel 
    GROUP BY LTRIM(RTRIM(  EducationLevel ))
);

--iam now clean data in  RatingLevel file

UPDATE  RatingLevel 
SET RatingLevel = LTRIM(RTRIM(RatingLevel));

DELETE FROM  RatingLevel 
WHERE RatingID NOT IN (
    SELECT MIN(RatingID)
    FROM  RatingLevel 
    GROUP BY LTRIM(RTRIM(RatingLevel))
);

--finally cleaning is finched