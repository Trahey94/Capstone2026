SELECT
    diag_1                          AS primary_diagnosis,
    COUNT(*)                        AS encounter_count,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM diabetic_data), 2)
                                    AS pct_of_total
FROM diabetic_data
WHERE diag_1 != '?'
GROUP BY diag_1
ORDER BY encounter_count DESC
LIMIT 10;

----
SELECT
    admission_type_id,
    CASE admission_type_id
        WHEN 1 THEN 'Emergency'
        WHEN 2 THEN 'Urgent'
        WHEN 3 THEN 'Elective'
        WHEN 4 THEN 'Newborn'
        WHEN 5 THEN 'Not Available'
        WHEN 6 THEN 'NULL'
        WHEN 7 THEN 'Trauma Center'
        WHEN 8 THEN 'Not Mapped'
        ELSE 'Unknown'
    END                                     AS admission_type_label,
    COUNT(*)                                AS encounter_count,
    ROUND(AVG(time_in_hospital), 2)         AS avg_days_in_hospital,
    MIN(time_in_hospital)                   AS min_days,
    MAX(time_in_hospital)                   AS max_days
FROM diabetic_data
GROUP BY admission_type_id
ORDER BY avg_days_in_hospital DESC;

-----
SELECT
    readmitted,
    COUNT(*)                                AS patient_count,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM diabetic_data), 2)
                                            AS pct_of_total
FROM diabetic_data
GROUP BY readmitted
ORDER BY patient_count DESC;

----
SELECT
    age                             AS age_group,
    COUNT(*)                        AS encounter_count,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM diabetic_data), 2)
                                    AS pct_of_total,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
                                    AS readmitted_within_30,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2)              AS readmission_rate_pct
FROM diabetic_data
GROUP BY age
ORDER BY age;

----
SELECT
    num_procedures,
    COUNT(*)                                AS encounter_count,
    ROUND(COUNT(*) * 100.0
          / (SELECT COUNT(*) FROM diabetic_data), 2)
                                            AS pct_of_total
FROM diabetic_data
GROUP BY num_procedures
ORDER BY encounter_count DESC;

----
SELECT
    age                                 AS age_group,
    COUNT(*)                            AS encounter_count,
    ROUND(AVG(num_medications), 2)      AS avg_medications,
    MIN(num_medications)                AS min_medications,
    MAX(num_medications)                AS max_medications,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2)                  AS readmission_rate_pct
FROM diabetic_data
GROUP BY age
ORDER BY age;

----
SELECT
    CASE
        WHEN payer_code = '?'   THEN 'Unknown'
        WHEN payer_code = 'MC'  THEN 'Medicare'
        WHEN payer_code = 'MD'  THEN 'Medicaid'
        WHEN payer_code = 'BC'  THEN 'Blue Cross'
        WHEN payer_code = 'HM'  THEN 'HMO'
        WHEN payer_code = 'SP'  THEN 'Self Pay'
        WHEN payer_code = 'CM'  THEN 'Champus'
        WHEN payer_code = 'CH'  THEN 'Champva'
        WHEN payer_code = 'WC'  THEN 'Workers Comp'
        WHEN payer_code = 'OT'  THEN 'Other'
        ELSE payer_code
    END                                         AS payer_type,
    COUNT(*)                                    AS total_encounters,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END)
                                                AS readmitted_within_30,
    SUM(CASE WHEN readmitted = '>30' THEN 1 ELSE 0 END)
                                                AS readmitted_after_30,
    SUM(CASE WHEN readmitted = 'NO'  THEN 1 ELSE 0 END)
                                                AS not_readmitted,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 2)                          AS readmission_rate_30day_pct
FROM diabetic_data
GROUP BY payer_code
ORDER BY readmission_rate_30day_pct DESC;