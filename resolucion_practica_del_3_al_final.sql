-- EJERCICIO 3


CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  c.ivr_id AS calls_ivr_id,
  c.phone_number AS calls_phone_number,
  c.ivr_result AS calls_ivr_result,
  c.vdn_label AS calls_vdn_label,
  c.start_date AS calls_start_date,
  FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS calls_start_date_id,
  c.end_date AS calls_end_date,
  FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS calls_end_date_id,
  c.total_duration AS calls_total_duration,
  c.customer_segment AS calls_customer_segment,
  c.ivr_language AS calls_ivr_language,
  c.steps_module AS calls_steps_module,
  c.module_aggregation AS calls_module_aggregation,
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_modules m ON c.ivr_id = m.ivr_id
LEFT JOIN keepcoding.ivr_steps s
  ON c.ivr_id = s.ivr_id
 AND m.module_sequece = s.module_sequece;

-- COMPROBACION
SELECT *
FROM keepcoding.ivr_detail
LIMIT 10;



-- EJERCICIO 4

CREATE OR REPLACE TABLE keepcoding.ivr_detail AS
SELECT
  c.ivr_id AS calls_ivr_id,
  c.phone_number AS calls_phone_number,
  c.ivr_result AS calls_ivr_result,
  c.vdn_label AS calls_vdn_label,
  CASE
    WHEN c.vdn_label LIKE 'ATC%' THEN 'FRONT'
    WHEN c.vdn_label LIKE 'TECH%' THEN 'TECH'
    WHEN c.vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
    ELSE 'RESTO'
  END AS vdn_aggregation,
  c.start_date AS calls_start_date,
  FORMAT_DATE('%Y%m%d', DATE(c.start_date)) AS calls_start_date_id,
  c.end_date AS calls_end_date,
  FORMAT_DATE('%Y%m%d', DATE(c.end_date)) AS calls_end_date_id,
  c.total_duration AS calls_total_duration,
  c.customer_segment AS calls_customer_segment,
  c.ivr_language AS calls_ivr_language,
  c.steps_module AS calls_steps_module,
  c.module_aggregation AS calls_module_aggregation,
  m.module_sequece,
  m.module_name,
  m.module_duration,
  m.module_result,
  s.step_sequence,
  s.step_name,
  s.step_result,
  s.step_description_error,
  s.document_type,
  s.document_identification,
  s.customer_phone,
  s.billing_account_id
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_modules m ON c.ivr_id = m.ivr_id
LEFT JOIN keepcoding.ivr_steps s
  ON c.ivr_id = s.ivr_id
 AND m.module_sequece = s.module_sequece;

-- COMPROBACION
SELECT vdn_aggregation, COUNT(*) AS filas
FROM keepcoding.ivr_detail
GROUP BY vdn_aggregation;


-- EJERCICIO 5

SELECT 
    calls_ivr_id,
    MAX(document_type) AS document_type,
    MAX(document_identification) AS document_identification
FROM 
    keepcoding.ivr_detail
GROUP BY 
    calls_ivr_id;

-- comprobacnion 

SELECT
  calls_ivr_id,
  document_type,
  document_identification
FROM keepcoding.ivr_detail
WHERE document_type IS NOT NULL
   OR document_identification IS NOT NULL
LIMIT 20;

-- EJERCICIO 6

SELECT 
    calls_ivr_id,
    MAX(CASE WHEN customer_phone != 'UNKNOWN' THEN customer_phone END) AS customer_phone
FROM 
    keepcoding.ivr_detail
GROUP BY 
    calls_ivr_id;


-- comprobacion

SELECT 
    COUNT(*) as total_registros,
    COUNT(customer_phone) as con_telefono,
    COUNT(*) - COUNT(customer_phone) as sin_telefono
FROM keepcoding.ivr_detail;


-- EJERCICIO 7

SELECT
  c.ivr_id AS calls_ivr_id,
  MAX(NULLIF(s.billing_account_id, 'UNKNOWN')) AS billing_account_id
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_steps s
  ON c.ivr_id = s.ivr_id
GROUP BY c.ivr_id;

-- comprobacion

SELECT
  COUNT(*) AS total_llamadas,
  COUNTIF(billing_account_id IS NOT NULL) AS llamadas_con_billing
FROM (
  SELECT
    c.ivr_id AS calls_ivr_id,
    MAX(NULLIF(s.billing_account_id, 'UNKNOWN')) AS billing_account_id
  FROM keepcoding.ivr_calls c
  LEFT JOIN keepcoding.ivr_steps s
    ON c.ivr_id = s.ivr_id
  GROUP BY c.ivr_id
);

-- ejercicio 8

SELECT
  c.ivr_id AS calls_ivr_id,
  MAX(CASE WHEN m.module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_modules m
  ON c.ivr_id = m.ivr_id
GROUP BY c.ivr_id;


-- EJERCICIO 9

SELECT
  c.ivr_id AS calls_ivr_id,
  MAX(CASE 
        WHEN s.step_name = 'CUSTOMERINFOBYPHONE.TX'
         AND s.step_result = 'OK'
        THEN 1 ELSE 0 END) AS info_by_phone_lg
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_steps s
  ON c.ivr_id = s.ivr_id
GROUP BY c.ivr_id;

-- comprobacion

SELECT
  COUNT(*) AS total_llamadas,
  SUM(CASE WHEN info_by_phone_lg = 1 THEN 1 ELSE 0 END) AS con_flag_1,
  SUM(CASE WHEN info_by_phone_lg = 0 THEN 1 ELSE 0 END) AS con_flag_0
FROM (
  SELECT
    c.ivr_id AS calls_ivr_id,
    MAX(CASE 
          WHEN s.step_name = 'CUSTOMERINFOBYPHONE.TX'
           AND s.step_result = 'OK'
          THEN 1 ELSE 0 END) AS info_by_phone_lg
  FROM keepcoding.ivr_calls c
  LEFT JOIN keepcoding.ivr_steps s
    ON c.ivr_id = s.ivr_id
  GROUP BY c.ivr_id
) t;

-- EJERCICIO 10

SELECT
  c.ivr_id AS calls_ivr_id,
  MAX(CASE 
        WHEN s.step_name = 'CUSTOMERINFOBYDNI.TX'
         AND s.step_result = 'OK'
        THEN 1 ELSE 0 END) AS info_by_dni_lg
FROM keepcoding.ivr_calls c
LEFT JOIN keepcoding.ivr_steps s
  ON c.ivr_id = s.ivr_id
GROUP BY c.ivr_id;

-- EJERCICIO 11

SELECT 
    c1.ivr_id AS calls_ivr_id,
    MAX(CASE WHEN c2.ivr_id IS NOT NULL THEN 1 ELSE 0 END) AS repeated_phone_24H,
    MAX(CASE WHEN c3.ivr_id IS NOT NULL THEN 1 ELSE 0 END) AS cause_recall_phone_24H
FROM 
    keepcoding.ivr_calls c1
    LEFT JOIN keepcoding.ivr_calls c2
        ON c1.phone_number = c2.phone_number
        AND c2.ivr_id != c1.ivr_id
        AND c2.start_date >= TIMESTAMP_SUB(c1.start_date, INTERVAL 24 HOUR)
        AND c2.start_date < c1.start_date
    LEFT JOIN keepcoding.ivr_calls c3
        ON c1.phone_number = c3.phone_number
        AND c3.ivr_id != c1.ivr_id
        AND c3.start_date > c1.start_date
        AND c3.start_date <= TIMESTAMP_ADD(c1.start_date, INTERVAL 24 HOUR)
GROUP BY 
    c1.ivr_id;

-- comprobacion

SELECT
  COUNT(*) AS total_llamadas,
  COUNTIF(repeated_phone_24H = 1)    AS repeated_1,
  COUNTIF(repeated_phone_24H = 0)    AS repeated_0,
  COUNTIF(cause_recall_phone_24H = 1) AS recall_1,
  COUNTIF(cause_recall_phone_24H = 0) AS recall_0
FROM (
  SELECT
    c.ivr_id AS calls_ivr_id,
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM keepcoding.ivr_calls c2
        WHERE c2.phone_number = c.phone_number
          AND c2.ivr_id <> c.ivr_id
          AND c2.start_date >= TIMESTAMP_SUB(c.start_date, INTERVAL 24 HOUR)
          AND c2.start_date <  c.start_date
      ) THEN 1 ELSE 0
    END AS repeated_phone_24H,
    CASE
      WHEN EXISTS (
        SELECT 1
        FROM keepcoding.ivr_calls c3
        WHERE c3.phone_number = c.phone_number
          AND c3.ivr_id <> c.ivr_id
          AND c3.start_date >  c.start_date
          AND c3.start_date <= TIMESTAMP_ADD(c.start_date, INTERVAL 24 HOUR)
      ) THEN 1 ELSE 0
    END AS cause_recall_phone_24H
  FROM keepcoding.ivr_calls c
);


-- EJERCICIO 12

CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
SELECT
    calls_ivr_id AS ivr_id,
    MAX(calls_phone_number) AS phone_number,
    MAX(calls_ivr_result) AS ivr_result,
    MAX(vdn_aggregation) AS vdn_aggregation,
    MAX(calls_start_date) AS start_date,
    MAX(calls_end_date) AS end_date,
    MAX(calls_total_duration) AS total_duration,
    MAX(calls_customer_segment) AS customer_segment,
    MAX(calls_ivr_language) AS ivr_language,
    COUNT(DISTINCT module_sequence) AS steps_module,
    STRING_AGG(DISTINCT module_name, ',') AS module_aggregation,
    MAX(CASE WHEN document_type != 'UNKNOWN' THEN document_type END) AS document_type,
    MAX(CASE WHEN document_identification != 'UNKNOWN' THEN document_identification END) AS document_identification,
    MAX(CASE WHEN customer_phone != 'UNKNOWN' THEN customer_phone END) AS customer_phone,
    MAX(CASE WHEN billing_account_id != 'UNKNOWN' THEN billing_account_id END) AS billing_account_id,
    MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg,
    MAX(CASE WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_phone_lg,
    MAX(CASE WHEN step_name = 'CUSTOMERINFOBYDNI.TX' AND step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_dni_lg,
    0 AS repeated_phone_24H,  
    0 AS cause_recall_phone_24H  
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id;


-- comprobacion
SELECT *
FROM keepcoding.ivr_summary
LIMIT 20;

-- EJERCICIO 13

CREATE OR REPLACE FUNCTION keepcoding.clean_integer(x INT64)
RETURNS INT64
AS (IFNULL(x, -999999));

-- compr

SELECT 
    keepcoding.clean_integer(NULL) as test_null,
    keepcoding.clean_integer(100) as test_number;

-- MUCHAS GRACIAS POR TODO, MUY CLARAS LAS EXPLICACIONES!!! ESTUVE BASTANTE ENFERMO LA PRIMERA SEMANA Y HE TENIDO QUE IR RELEGADO VIENDO LO GRABADO. SALUDOS.