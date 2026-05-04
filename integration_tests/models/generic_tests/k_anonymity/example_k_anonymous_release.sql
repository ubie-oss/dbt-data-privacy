{{ config(materialized="view") }}

SELECT 'G1' AS qi_a, 'X' AS qi_b
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b
