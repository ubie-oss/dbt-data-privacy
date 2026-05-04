{{ config(materialized="view") }}

{# Three QI groups; each (qi_a, qi_b) has 5 rows with sensitives S1,S1,S2,S2,S3 => COUNT(DISTINCT sensitive) = 3. #}
SELECT 'G1' AS qi_a, 'X' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G1' AS qi_a, 'X' AS qi_b, 'S3' AS sensitive
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G2' AS qi_a, 'Y' AS qi_b, 'S3' AS sensitive
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b, 'S1' AS sensitive
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b, 'S2' AS sensitive
UNION ALL
SELECT 'G3' AS qi_a, 'Z' AS qi_b, 'S3' AS sensitive
