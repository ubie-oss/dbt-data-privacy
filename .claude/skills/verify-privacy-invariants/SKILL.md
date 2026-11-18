---
name: verify-privacy-invariants
description: Bounded exhaustive check that the restructure and SQL generation path never leaks raw values of hashed or dropped columns and emits the correct converted level. Use when changing secured-expression logic, get_secured_columns_v2, get_secured_restructured_column, get_secured_expression_by_method, sha256, sha512, convert_restructured_column_to_expression, or the level handling in the codegen macros. Also use after any change to data handling standards fixtures.
---

# Verify privacy invariants

## What it checks

The check enumerates every assignment of `public`, `confidential`, `restricted`, or no level to six leaf columns. The leaves cover a scalar, a struct with two fields, an array of structs with two fields, and a scalar array. That is 4^6 = 4096 assignments. For each one it runs the real `dbt_data_privacy.get_secured_columns_v2` and `dbt_data_privacy.convert_restructured_column_to_expression`.

The expected results come from a small oracle written from the policy table, not from the macros:

| Leaf level | Method | Expected output | Expected converted level |
| :--- | :--- | :--- | :--- |
| `public` | RAW | raw reference | `public` |
| `confidential` | SHA256 | `SHA256(CAST(x AS STRING))`, or `ARRAY(SELECT SHA256(...) FROM UNNEST(x) AS e)` for arrays | `internal` |
| `restricted` | DROPPED | no expression, not in SQL | not checked (not in output) |
| none | none | no expression, not in SQL | not checked |

Invariants:

- **P1, no raw leak.** A confidential leaf appears in SQL only inside its hash expression. A restricted or unlabeled leaf does not appear in the SQL at all.
- **P4, level truth.** A kept confidential leaf carries the converted level from the standard.

Bounds: the matrix uses the fixture standards from `integration_tests/macros/test_utils/get_test_data_handling_standards.sql`, which are `public` RAW, `confidential` SHA256 converted to `internal`, and `restricted` DROPPED. A second pass checks `SHA512`, `UDF_HASH`, and each `CONDITIONAL_HASH` shape directly, one case at a time, against an oracle. The check does not cover policy-tag conditions, relationship joins, `where` filters, or the emitted schema YAML. P4 is checked on the restructured output, not on the YAML text.

## Run it

From the repository root:

```bash
cd integration_tests
uv sync --group dbt-core-1-12        # once, or after uv.lock changes
uv run --group dbt-core-1-12 dbt deps --profiles-dir profiles --target bigquery   # once per fresh checkout
uv run --group dbt-core-1-12 dbt run-operation verify_privacy_invariants \
  --profiles-dir profiles --target bigquery \
  --vars "$(cat resources/vars/vars-bigquery.basic.json)"
```

No BigQuery connection is needed. A pass ends with `SUCCESS: P1 and P4 hold for all 4096 level assignments` and exit code 0. A run takes about 45 seconds.

Use `uv run` rather than a globally installed `dbt`, so the version matches the lockfile.

## Read a failure

A failure raises a compilation error that names the property and the leaf, for example:

```
FAILED P1/expr: confidential leaf c_one expected SHA256(CAST(c_one AS STRING)) got c_one for levels [...]
```

Decide whether the failure is a real bug or a modeling error:

1. Open the leaf's path in the code: `get_secured_expression_by_method`, then `get_secured_restructured_column`, then `convert_restructured_column_to_expression`.
2. If the product code now does something the policy table does not allow, it is a real bug. Report it with the counterexample in these terms: the levels, the leaf, and the SQL. Do not change the check to pass.
3. If the policy itself changed on purpose, for example a new converted level or a method change, update the oracle in `privacy_invariants.sql` to match the new policy, and say so in the change.

Never weaken P1 or P4 to make the check pass.

## Prove the check still catches breaks

After changing the check itself, confirm that it fails on a broken product path:

1. Back up the file you will break.
2. Make a scratch break. Examples that have been verified: in `get_secured_expression_by_method`, make the `SHA256` branch return the raw `expression`, or replace `{# do nothing #}` in the `DROPPED` branch with `{% set secured_expression = expression %}`.
3. Run the check. It must fail with a `FAILED P1/...` message.
4. Restore the file. Run `git status`. Only intended changes should remain.
5. Run the check again. It must pass.

## Covered code

- Covered files and functions:
  - `macros/utils/expressions/get_secured_columns_v2.sql`
  - `macros/utils/expressions/get_secured_restructured_column.sql`
  - `macros/utils/expressions/get_secured_expression_by_level.sql`
  - `macros/utils/expressions/get_secured_expression_by_method.sql` (RAW, SHA256, DROPPED branches)
  - `macros/utils/expressions/convert_restructured_column_to_expression.sql` (`bigquery__` scalar, struct, and array-of-struct branches)
  - `macros/utils/expressions/get_column_data_security_level.sql`
  - `macros/pseudonymization/sha256.sql` (scalar and `ARRAY` branches)
  - `macros/system/get_data_handling_standard_by_level.sql` (called through the restructure path)

After a change to any covered file, rerun the check.

## Files

- Check: `integration_tests/macros/verify/privacy_invariants.sql`
- This skill: `.claude/skills/verify-privacy-invariants/SKILL.md`
