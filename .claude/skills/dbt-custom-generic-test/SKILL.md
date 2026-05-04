---
name: dbt-custom-generic-test
description: >-
  Implement or refactor a dbt custom generic data test using this package’s patterns (test block, adapter.dispatch,
  BigQuery-only implementations, macro property YAML, integration_tests fixtures). Use when adding a new generic test,
  splitting test/query/validation macros, fixing undefined test_* macros from a package, or aligning with dbt’s
  generic test docs.
---

# dbt custom generic data test (this repo)

## When to use

- Adding or changing a **custom generic data test** (`{% test my_test(model, column_name, ...) %}`).
- Wiring **adapter.dispatch** for warehouse-specific SQL (here: BigQuery).
- Adding **macro schema** docs (`macros:` / `test_<name>`) or an **integration_tests** model + `data_tests`.
- Debugging **`test_<name>` is undefined** or shadowing between the package and `integration_tests`.

## When not to use

- Singular (data) tests in `tests/` that are not reusable generic tests—use normal dbt test guidance.
- Warehouse features unrelated to test macro structure.

## Workflow (short)

1. Read the official guide: [Writing custom generic data tests](https://docs.getdbt.com/best-practices/writing-custom-generic-tests?version=1.12) (standard args, YAML usage, documenting `test_<name>`).
2. Open the **detailed checklist**: [references/checklist.md](references/checklist.md).
3. Mirror the **k_anonymity** layout under `macros/generic_tests/<name>/` and integration fixtures under `integration_tests/models/generic_tests/<name>/` unless there is a reason not to.
4. Validate with `make run-unit-tests`; use `make run-integration-tests` when SQL execution or BigQuery behavior changes (see `AGENTS.md`).

This skill keeps **SKILL.md** short for discovery and puts procedural detail in **references/checklist.md** (progressive disclosure).

## Canonical paths (examples)

| Concern | Example in repo |
|--------|-------------------|
| Generic test + `bigquery__test_*` (k-anonymity) | [`macros/generic_tests/k_anonymity/k_anonymity.sql`](../../../macros/generic_tests/k_anonymity/k_anonymity.sql) |
| Generic test + `bigquery__test_*` (l-diversity) | [`macros/generic_tests/l_diversity/l_diversity.sql`](../../../macros/generic_tests/l_diversity/l_diversity.sql) |
| Validation + query SQL | [`k_anonymity_validate_arguments.sql`](../../../macros/generic_tests/k_anonymity/k_anonymity_validate_arguments.sql), [`k_anonymity_query_sql_impl.sql`](../../../macros/generic_tests/k_anonymity/k_anonymity_query_sql_impl.sql) |
| Macro property docs | [`k_anonymity.yml`](../../../macros/generic_tests/k_anonymity/k_anonymity.yml) (`name: test_k_anonymity`) |
| Integration fixture + qualified test | [`schema.yml`](../../../integration_tests/models/generic_tests/k_anonymity/schema.yml) (`dbt_data_privacy.k_anonymity`) |
| Macro unit test (name must not shadow generic test) | [`test_k_anonymity.sql`](../../../integration_tests/macros/tests/generic_tests/test_k_anonymity.sql) |
| Macro unit test (l-diversity) | [`test_l_diversity.sql`](../../../integration_tests/macros/tests/generic_tests/test_l_diversity.sql) |

## Constraints specific to dbt-data-privacy

- **BigQuery only** for new generic tests unless the maintainers expand adapters.
- Prefer **minimal** behavior changes; keep existing tests green.
- Do not use Jinja delimiters inside macro **property** YAML `description` fields (dbt compiles those files as Jinja).
