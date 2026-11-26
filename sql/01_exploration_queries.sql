create database Pro2

select * from heart_2020_cleaned

-- Check abnormal BMI (<18.5 or >29.9)
SELECT *
FROM heart_2020_cleaned
WHERE BMI < 18.5 OR BMI > 29.9;


-- Distribution of HeartDisease by Smoking

SELECT Smoking,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int)) AS heart_cases
FROM heart_2020_cleaned
GROUP BY Smoking;

--  Average BMI, PhysicalHealth, MentalHealth by AgeCategory

SELECT AgeCategory,
       AVG(BMI) AS avg_bmi,
       AVG(PhysicalHealth) AS avg_physical_health,
       AVG(MentalHealth) AS avg_mental_health
FROM heart_2020_cleaned
GROUP BY AgeCategory;

--  Patients with multiple chronic diseases

SELECT COUNT(*) AS multi_disease_patients
FROM (
    SELECT 
           (cast(HeartDisease as int ) +
            cast(Stroke as int )+
           cast(Asthma as int)+
            cast(KidneyDisease as int)+
            cast(SkinCancer as int)) AS disease_count
    FROM heart_2020_cleaned
) t
WHERE disease_count >= 2;

-- Risk by SleepTime

SELECT SleepTime,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int )) AS heart_cases
FROM heart_2020_cleaned
GROUP BY SleepTime
ORDER BY heart_cases DESC;


-- Distribution of patients by Sex

SELECT Sex,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int )) AS heart_cases
FROM heart_2020_cleaned
GROUP BY Sex;


-- Correlation between BMI and PhysicalHealth

SELECT
    (SUM((BMI - avg_bmi) * (PhysicalHealth - avg_physical)) /
     SQRT(SUM(POWER(BMI - avg_bmi, 2)) * SUM(POWER(PhysicalHealth - avg_physical, 2)))) AS bmi_physical_corr
FROM (
    SELECT BMI, PhysicalHealth,
           (SELECT AVG(BMI) FROM heart_2020_cleaned) AS avg_bmi,
           (SELECT AVG(PhysicalHealth) FROM heart_2020_cleaned) AS avg_physical
    FROM heart_2020_cleaned
) t;

-- HeartDisease prevalence by PhysicalActivity

SELECT PhysicalActivity,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int )) AS heart_cases
FROM heart_2020_cleaned
GROUP BY PhysicalActivity;

-- Patients by Race

SELECT Race,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int )) AS heart_cases
FROM heart_2020_cleaned
GROUP BY Race;

-- Top 5 AgeGroups with avg SleepTime

SELECT  top 5 AgeCategory,
       AVG(SleepTime) AS avg_SleepTime
FROM heart_2020_cleaned
GROUP BY AgeCategory;

-- Relationship between BMI category and HeartDisease prevalence

SELECT BMI,
       COUNT(*) AS total_patients,
       SUM(cast(HeartDisease as int)) AS heart_cases,
       ROUND(SUM(cast(HeartDisease as int))*100.0/COUNT(*),2) AS heart_percent
FROM heart_2020_cleaned
GROUP BY BMI
ORDER BY BMI DESC;


-- SleepTime vs PhysicalHealth & MentalHealth averages

SELECT SleepTime,
       AVG(PhysicalHealth) AS avg_physical_health,
       AVG(MentalHealth) AS avg_mental_health
FROM heart_2020_cleaned
GROUP BY SleepTime
ORDER BY avg_physical_health DESC;


-- Patients with extreme Physical/Mental Health but no HeartDisease

SELECT *
FROM heart_2020_cleaned
WHERE HeartDisease = 0
  AND (PhysicalHealth >= 25 OR MentalHealth >= 25)
ORDER BY PhysicalHealth DESC, MentalHealth DESC;
