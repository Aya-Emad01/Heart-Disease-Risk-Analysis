import pandas as pd

df = pd.read_csv("heart_disease_transformed.csv")

# -----------------------------------
# patients table
# -----------------------------------
patients_cols = [
    'patient_Id', 'Sex', 'AgeCategory', 'age_group', 'Race_Asian', 'Race_Black', 
    'Race_Hispanic', 'Race_Other', 'Race_White', 'GenHealth', 'GenHealth_num'
]
patients = df[patients_cols].copy()
patients = patients.drop_duplicates(subset=['patient_Id'])
patients.to_csv("patients.csv", index=False)

# -----------------------------------
# lifestyle table
# -----------------------------------
lifestyle_cols = ['Smoking', 'AlcoholDrinking', 'PhysicalActivity', 'BMI', 'bmi_category', 'sleep_category']
lifestyle = df[lifestyle_cols].copy()
lifestyle.insert(0, 'lifestyle_id', range(1, len(lifestyle)+1))
lifestyle.insert(1, 'patient_Id', patients['patient_Id'])
lifestyle.to_csv("lifestyle.csv", index=False)

# -----------------------------------
# vitals table
# -----------------------------------
vitals_cols = ['PhysicalHealth', 'MentalHealth', 'physical_health_level', 'mental_health_level', 'DiffWalking']
vitals = df[vitals_cols].copy()
vitals.insert(0, 'vitals_id', range(1, len(vitals)+1))
vitals.insert(1, 'patient_Id', patients['patient_Id'])
vitals.to_csv("vitals.csv", index=False)

# -----------------------------------
# lab_results table
# -----------------------------------
lab_cols = ['HeartDisease', 'Stroke', 'Diabetic', 'Diabetic_num']
lab_results = df[lab_cols].copy()
lab_results.insert(0, 'lab_id', range(1, len(lab_results)+1))
lab_results.insert(1, 'patient_Id', patients['patient_Id'])
lab_results.to_csv("lab_results.csv", index=False)

# -----------------------------------
# diagnosis table
# -----------------------------------
diagnosis_cols = ['Asthma', 'KidneyDisease', 'SkinCancer']
diagnosis = df[diagnosis_cols].copy()
diagnosis.insert(0, 'diagnosis_id', range(1, len(diagnosis)+1))
diagnosis.insert(1, 'patient_Id', patients['patient_Id'])
diagnosis.to_csv("diagnosis.csv", index=False)

print("Normalized tables created successfully!")
print("Tables:")
print(" - patients.csv")
print(" - lifestyle.csv")
print(" - vitals.csv")
print(" - lab_results.csv")
print(" - diagnosis.csv")
