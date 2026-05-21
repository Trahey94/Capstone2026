-- 1: CREATE THE TABLE
----

DROP TABLE IF EXISTS diabetic_data;

CREATE TABLE diabetic_data (
    encounter_id                INTEGER,
    patient_nbr                 INTEGER,
    race                        TEXT,
    gender                      TEXT,
    age                         TEXT,
    weight                      TEXT,
    admission_type_id           INTEGER,
    discharge_disposition_id    INTEGER,
    admission_source_id         INTEGER,
    time_in_hospital            INTEGER,
    payer_code                  TEXT,
    medical_specialty           TEXT,
    num_lab_procedures          INTEGER,
    num_procedures              INTEGER,
    num_medications             INTEGER,
    number_outpatient           INTEGER,
    number_emergency            INTEGER,
    number_inpatient            INTEGER,
    diag_1                      TEXT,
    diag_2                      TEXT,
    diag_3                      TEXT,
    number_diagnoses            INTEGER,
    max_glu_serum               TEXT,
    A1Cresult                   TEXT,
    metformin                   TEXT,
    repaglinide                 TEXT,
    nateglinide                 TEXT,
    chlorpropamide              TEXT,
    glimepiride                 TEXT,
    acetohexamide               TEXT,
    glipizide                   TEXT,
    glyburide                   TEXT,
    tolbutamide                 TEXT,
    pioglitazone                TEXT,
    rosiglitazone               TEXT,
    acarbose                    TEXT,
    miglitol                    TEXT,
    troglitazone                TEXT,
    tolazamide                  TEXT,
    examide                     TEXT,
    citoglipton                 TEXT,
    insulin                     TEXT,
    "glyburide-metformin"       TEXT,
    "glipizide-metformin"       TEXT,
    "glimepiride-pioglitazone"  TEXT,
    "metformin-rosiglitazone"   TEXT,
    "metformin-pioglitazone"    TEXT,
    change_flag                 TEXT,
    diabetesMed                 TEXT,
    readmitted                  TEXT
);

---
-- 2: IMPORT DATA
---

---
-- Total number of patient encounters
---

SELECT COUNT(*) AS total_encounters
FROM diabetic_data;

---
-- Total number of unique patients
---

SELECT COUNT(DISTINCT patient_nbr) AS unique_patients
FROM diabetic_data;

---
-- Top 10 most frequent primary diagnoses (diag_1)
---

SELECT
    diag_1                      AS primary_diagnosis,
    COUNT(*)                    AS encounter_count
FROM diabetic_data
WHERE diag_1 != '?'
GROUP BY diag_1
ORDER BY encounter_count DESC
LIMIT 10;

---
-- Average length of hospital stay by admission type
-- admission_type_id: 1=Emergency, 2=Urgent, 3=Elective, 4=Newborn, 5=Not Available
---

SELECT
    admission_type_id,
    COUNT(*)                            AS total_encounters,
    ROUND(AVG(time_in_hospital), 2)     AS avg_days_in_hospital
FROM diabetic_data
GROUP BY admission_type_id
ORDER BY admission_type_id;

---
-- 5: Number and percentage of readmitted patients (readmitted within 30 days)
---

SELECT
    readmitted,
    COUNT(*)                                            AS encounter_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM diabetic_data), 1) AS pct_of_total
FROM diabetic_data
GROUP BY readmitted
ORDER BY encounter_count DESC;

---
-- 6: Age distribution of patients
---

SELECT
    age                 AS age_group,
    COUNT(*)            AS patient_count
FROM diabetic_data
GROUP BY age
ORDER BY age;

---
-- QUERY 7: Most common number of procedures performed
---

SELECT
    num_procedures,
    COUNT(*) AS encounter_count
FROM diabetic_data
GROUP BY num_procedures
ORDER BY num_procedures;

---
-- 8: Average number of medications prescribed per age group
---

SELECT
    age                                     AS age_group,
    ROUND(AVG(num_medications), 2)          AS avg_medications,
    COUNT(*)                                AS total_encounters
FROM diabetic_data
GROUP BY age
ORDER BY age;

---
-- 9: Readmission rate by payer code
-- Excludes missing payer codes encoded as '?'
---

SELECT
    payer_code,
    COUNT(*)                                                        AS total_encounters,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)            AS readmitted_under_30,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    )                                                               AS readmit_rate_pct
FROM diabetic_data
WHERE payer_code != '?'
GROUP BY payer_code
ORDER BY readmit_rate_pct DESC;

---
-- 10: Missing value counts for key columns
-- Note: Dataset uses '?' to represent missing values
---

SELECT
    SUM(CASE WHEN weight           = '?' THEN 1 ELSE 0 END) AS missing_weight,
    SUM(CASE WHEN race             = '?' THEN 1 ELSE 0 END) AS missing_race,
    SUM(CASE WHEN payer_code       = '?' THEN 1 ELSE 0 END) AS missing_payer_code,
    SUM(CASE WHEN medical_specialty= '?' THEN 1 ELSE 0 END) AS missing_medical_specialty,
    SUM(CASE WHEN diag_1           = '?' THEN 1 ELSE 0 END) AS missing_diag_1,
    SUM(CASE WHEN diag_2           = '?' THEN 1 ELSE 0 END) AS missing_diag_2,
    SUM(CASE WHEN diag_3           = '?' THEN 1 ELSE 0 END) AS missing_diag_3
FROM diabetic_data;