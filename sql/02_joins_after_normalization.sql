
-- Show patient_id, age_group, sex, and smoking status

SELECT p.patient_Id, p.age_group, p.Sex, l.Smoking
FROM patients p
INNER JOIN lifestyle l ON p.patient_Id = l.patient_Id;


-- Show all patients and their vitals data (even if missing)

SELECT p.patient_Id, v.PhysicalHealth, v.MentalHealth, v.DiffWalking
FROM patients p
LEFT JOIN vitals v ON p.patient_Id = v.patient_Id;

-- Show all patients with their lab_results

SELECT p.patient_Id, l.HeartDisease, l.Stroke, l.Diabetic, l.Diabetic_num
FROM patients p
LEFT JOIN lab_results l ON p.patient_Id = l.patient_Id;


-- Show all patients with diagnosis

SELECT p.patient_Id, d.Asthma, d.KidneyDisease, d.SkinCancer
FROM patients p
LEFT JOIN diagnosis d ON p.patient_Id = d.patient_Id;


-- Average BMI per age_group

SELECT p.age_group, AVG(l.BMI) AS avg_BMI
FROM patients p
INNER JOIN lifestyle l ON p.patient_Id = l.patient_Id
GROUP BY p.age_group;


-- Count patients per disease in lab_results

SELECT 
    SUM(CAST(l.HeartDisease AS int)) AS heart_disease_count,
    SUM(CAST(l.Stroke AS int)) AS stroke_count,
    SUM(CAST(l.Diabetic_num AS int)) AS diabetic_count
FROM lab_results l;


-- Average Physical and Mental Health by Sex

SELECT p.Sex, AVG(v.PhysicalHealth) AS avg_physical, AVG(v.MentalHealth) AS avg_mental
FROM patients p
INNER JOIN vitals v ON p.patient_Id = v.patient_Id
GROUP BY p.Sex;


-- Patients with highest BMI

SELECT TOP 5 patient_Id, BMI
FROM lifestyle
ORDER BY BMI DESC;


-- Patients with HeartDisease and BMI > 30

SELECT p.patient_Id, l.BMI, la.HeartDisease
FROM patients p
INNER JOIN lab_results la ON p.patient_Id = la.patient_Id
INNER JOIN Lifestyle  l ON p.patient_Id = l.patient_Id
WHERE la.HeartDisease = 1 AND l.BMI > 30;

 
-- Average BMI per PhysicalActivity level

SELECT l.PhysicalActivity, AVG(l.BMI) AS avg_BMI
FROM lifestyle l
GROUP BY l.PhysicalActivity;


-- Multi-disease patients (>=2 chronic diseases)

SELECT p.patient_Id,
       (cast(l.HeartDisease as int) + cast(l.Stroke as int )
       + cast(l.Diabetic_num as int) + cast(d.Asthma as int )
       + cast(d.KidneyDisease as int) + cast(d.SkinCancer as int)) AS disease_count
FROM patients p
INNER JOIN lab_results l ON p.patient_Id = l.patient_Id
INNER JOIN diagnosis d ON p.patient_Id = d.patient_Id
WHERE (cast(l.HeartDisease as int) + cast(l.Stroke as int )
       + cast(l.Diabetic_num as int) + cast(d.Asthma as int )
       + cast(d.KidneyDisease as int) + cast(d.SkinCancer as int) )>= 2;


-- Average PhysicalHealth and MentalHealth per Sleep Category

SELECT l.sleep_category, AVG(v.PhysicalHealth) AS avg_physical, AVG(v.MentalHealth) AS avg_mental
FROM lifestyle l
INNER JOIN vitals v ON l.patient_Id = v.patient_Id
GROUP BY l.sleep_category;


-- Patients by Race with HeartDisease

SELECT 
    CASE 
        WHEN p.Race_Asian = 1 THEN 'Asian'
        WHEN p.Race_Black = 1 THEN 'Black'
        WHEN p.Race_Hispanic = 1 THEN 'Hispanic'
        WHEN p.Race_Other = 1 THEN 'Other'
        WHEN p.Race_White = 1 THEN 'White'
    END AS Race,
    COUNT(*) AS total_patients,
    SUM(cast(l.HeartDisease as int )) AS heart_cases
FROM patients p
INNER JOIN lab_results l ON p.patient_Id = l.patient_Id
GROUP BY 
    CASE 
        WHEN p.Race_Asian = 1 THEN 'Asian'
        WHEN p.Race_Black = 1 THEN 'Black'
        WHEN p.Race_Hispanic = 1 THEN 'Hispanic'
        WHEN p.Race_Other = 1 THEN 'Other'
        WHEN p.Race_White = 1 THEN 'White'
    END;


-- Top patients in BMI per age_group

SELECT top 10  p.age_group, p.patient_Id, l.BMI
FROM patients p
INNER JOIN lifestyle l ON p.patient_Id = l.patient_Id
ORDER BY p.age_group, l.BMI DESC;


-- Patients with Diabetes and BMI > 25

SELECT p.patient_Id, l.BMI, la.Diabetic_num
FROM patients p
INNER JOIN lifestyle l ON p.patient_Id = l.patient_Id
INNER JOIN lab_results la ON p.patient_Id = la.patient_Id
WHERE la.Diabetic_num = 1 AND l.BMI > 25;

-- Average BMI per BMI Category 

SELECT bmi_category, AVG(BMI) AS avg_BMI        
FROM lifestyle 
GROUP BY bmi_category;
