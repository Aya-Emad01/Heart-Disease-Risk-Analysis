import pandas as pd
import numpy as np


df = pd.read_csv("heart_2020_cleaned.csv")

print(df.columns)
print(df.info())
print(df.describe())
print("Nulls :- \n", df.isna().sum())
print("------------------------------")
print("Duplicated =", df.duplicated().sum())   
print("------------------------------")
df = df.drop_duplicates()
print("Duplicated after drop =", df.duplicated().sum())
print("------------------------------")

# ----------------------------------------------------
# Insert patient_Id as unique identifier
# ----------------------------------------------------

df.insert(0, 'patient_Id', range(1, len(df) + 1))

# ----------------------------------------------------
# Convert Yes/No binary columns → 1/0
# ----------------------------------------------------
binary_cols = [
    'HeartDisease', 'Smoking', 'AlcoholDrinking', 'Stroke',
    'DiffWalking', 'PhysicalActivity', 'Asthma',
    'KidneyDisease', 'SkinCancer'
]

for col in binary_cols:
    df[col] = df[col].map({'Yes': 1, 'No': 0})


# ----------------------------------------------------
# Clean ONLY categorical columns (strings)
# ----------------------------------------------------
for col in df.select_dtypes(include=['object']).columns:
    df[col] = df[col].fillna("Unknown").astype("string").str.strip()


# ----------------------------------------------------
# Convert numeric columns safely (ignore non-numeric)
# ----------------------------------------------------
for col in df.columns:
    df[col] = pd.to_numeric(df[col], errors='ignore')

print(df.dtypes)


# ----------------------------------------------------
# AgeCategory → ordinal encoding + create age_group
# ----------------------------------------------------
age_map = {
    "18-24": 1, "25-29": 2, "30-34": 3, "35-39": 4, "40-44": 5,
    "45-49": 6, "50-54": 7, "55-59": 8, "60-64": 9, "65-69": 10,
    "70-74": 11, "75-79": 12, "80 or older": 13
}

df["AgeCategory_num"] = df["AgeCategory"].map(age_map)

# Numeric age grouping
df['age_group'] = pd.cut(
    df['AgeCategory_num'],
    bins=[0, 4, 8, 11, 14],
    labels=['Young', 'Mid-Age', 'Senior', 'Old']
)


# ----------------------------------------------------
# BMI Category
# ----------------------------------------------------
df['bmi_category'] = pd.cut(
    df['BMI'],
    bins=[0, 18.5, 24.9, 29.9, 100],
    labels=['Underweight', 'Normal', 'Overweight', 'Obese'],
    right=True
)


# ----------------------------------------------------
# General Health (GenHealth) → ordinal numeric
# ----------------------------------------------------
gen_health_map = {
    "Poor": 1,
    "Fair": 2,
    "Good": 3,
    "Very good": 4,
    "Excellent": 5
}

df["GenHealth_num"] = df["GenHealth"].map(gen_health_map)


# ----------------------------------------------------
# Diabetes Column Mapping
# ----------------------------------------------------
diabetic_map = {
    "No": 0,
    "No, borderline diabetes": 1,
    "Yes (during pregnancy)": 1,
    "Yes": 2
}
df["Diabetic_num"] = df["Diabetic"].map(diabetic_map)


# ----------------------------------------------------
# SleepTime Grouping
# ----------------------------------------------------
df['sleep_category'] = pd.cut(
    df['SleepTime'],
    bins=[0, 5, 7, 10, 24],
    labels=['Low Sleep', 'Normal Sleep', 'Good Sleep', 'High Sleep']
)


# ----------------------------------------------------
# Mental Health / Physical Health categorization
# ----------------------------------------------------
df['mental_health_level'] = pd.cut(
    df['MentalHealth'],
    bins=[-1, 7, 15, 30],
    labels=['Low', 'Medium', 'High']
)

df['physical_health_level'] = pd.cut(
    df['PhysicalHealth'],
    bins=[-1, 7, 15, 30],
    labels=['Low', 'Medium', 'High']
)


# ----------------------------------------------------
# One-Hot Encoding for Race
# ----------------------------------------------------
df = pd.get_dummies(df, columns=["Race"], prefix="Race", drop_first=True)

for col in df.columns:
    if "Race_" in col:
        df[col] = df[col].astype(int)

# ----------------------------------------------------
# Save final transformed dataset
# ----------------------------------------------------
df.to_csv("heart_disease_transformed.csv", index=False)

print("Transformation Completed Successfully!")
