# Generic tests (dbt-data-privacy)

Package overview: [README](../../README.md).

## k_anonymity

Validates [k-anonymity](https://en.wikipedia.org/wiki/K-anonymity) on a **caller-chosen** set of quasi-identifier columns: every distinct tuple of those columns must appear on **at least `k` rows**. The test uses an **exact** `GROUP BY` / `COUNT(*)` check (see [custom generic tests](https://docs.getdbt.com/best-practices/writing-custom-generic-data-tests?version=1.12)). It does **not** generalize or suppress data for you; it only fails if any equivalence class is too small.

The generic test is implemented for **BigQuery only** (`bigquery__test_k_anonymity`); there is no `default__` fallback for other adapters.

Macros live under [`macros/generic_tests/k_anonymity/`](../../macros/generic_tests/k_anonymity/): [`k_anonymity.sql`](../../macros/generic_tests/k_anonymity/k_anonymity.sql) (test + `bigquery__test_k_anonymity`), [`k_anonymity_validate_arguments.sql`](../../macros/generic_tests/k_anonymity/k_anonymity_validate_arguments.sql), and [`k_anonymity_query_sql_impl.sql`](../../macros/generic_tests/k_anonymity/k_anonymity_query_sql_impl.sql) (`k_anonymity_test_query_sql` and `bigquery__k_anonymity_query_sql_impl`).

**Semantics**

- **Pass:** the compiled query returns zero rows.
- **Fail:** up to `sample_limit` rows are returned. Each row includes the quasi-identifier columns, `group_size`, and `total_violating_groups` (count of violating classes; repeated on each sampled row). Groups are ordered by smallest `group_size` first.
- **NULLs:** standard SQL `GROUP BY` behavior (NULL groups with NULL).

**Arguments**

| Name | Required | Description |
|------|----------|-------------|
| `quasi_identifiers` | yes | Non-empty list of column names on the model (no duplicate names). |
| `k` | yes | Minimum class size; integer ≥ 1 (privacy practice often uses k ≥ 2). |
| `sample_limit` | no | Max rows returned on failure; default `50`. |
| `column_name` | no | Ignored; included so the test can be attached at column or model level. |

**Compiled SQL (tests and debugging)**

`dbt_data_privacy.k_anonymity_test_query_sql(model, quasi_identifiers, k, sample_limit)` returns the same SQL string the generic test executes (after validation). Use it in macro unit tests or to inspect the query; it dispatches to BigQuery-specific SQL only.

**Example (model-level `data_tests`)**

If your project sets `require_generic_test_arguments_property: true`, nest parameters under `arguments`:

When this package is installed as a dependency, qualify the test with the package name (for example `dbt_data_privacy.k_anonymity` in YAML) so dbt resolves `test_k_anonymity` from the package rather than the root project.

```yaml
models:
  - name: my_release_model
    data_tests:
      - dbt_data_privacy.k_anonymity:
          arguments:
            quasi_identifiers: [age_band, gender, postal_sector]
            k: 5
            sample_limit: 20
```

Otherwise you can pass the same parameters at the top level of the test node (see your dbt version and project flags).

## l_diversity

Validates **distinct l-diversity** on a caller-chosen set of **quasi-identifier** columns and one **sensitive** column: within each distinct tuple of quasi-identifiers, the sensitive column must take **at least `l` distinct values** (`COUNT(DISTINCT)`). This mitigates the **homogeneity attack** on k-anonymous tables (see [k-anonymity](https://en.wikipedia.org/wiki/K-anonymity) and related models). The test uses an **exact** `GROUP BY` check (see [custom generic tests](https://docs.getdbt.com/best-practices/writing-custom-generic-data-tests?version=1.12)). It does not transform data; it only fails if any equivalence class has too few distinct sensitive values.

For microdata-style releases, use **`l_diversity` together with `k_anonymity`**: k limits how rare a QI tuple is; l limits how homogeneous the sensitive attribute is within each tuple class.

The generic test is implemented for **BigQuery only** (`bigquery__test_l_diversity`); there is no `default__` fallback for other adapters.

Macros live under [`macros/generic_tests/l_diversity/`](../../macros/generic_tests/l_diversity/): [`l_diversity.sql`](../../macros/generic_tests/l_diversity/l_diversity.sql) (test + `bigquery__test_l_diversity`), [`l_diversity_resolve_sensitive_column.sql`](../../macros/generic_tests/l_diversity/l_diversity_resolve_sensitive_column.sql), [`l_diversity_validate_arguments.sql`](../../macros/generic_tests/l_diversity/l_diversity_validate_arguments.sql), and [`l_diversity_query_sql_impl.sql`](../../macros/generic_tests/l_diversity/l_diversity_query_sql_impl.sql) (`l_diversity_test_query_sql` and `bigquery__l_diversity_query_sql_impl`).

**Semantics**

- **Pass:** the compiled query returns zero rows.
- **Fail:** up to `sample_limit` rows are returned. Each row includes the quasi-identifier columns, `group_size`, `distinct_sensitive_count`, and `total_violating_groups` (count of violating classes; repeated on each sampled row). Groups are ordered by smallest `distinct_sensitive_count` first.
- **NULLs (QI):** standard SQL `GROUP BY` behavior (NULL groups with NULL).
- **NULLs (sensitive):** `COUNT(DISTINCT sensitive)` does not count NULLs; if all sensitive values in a class are NULL, `distinct_sensitive_count` is 0 and the class fails for any `l >= 1`.

**Arguments**

| Name | Required | Description |
|------|----------|-------------|
| `quasi_identifiers` | yes | Non-empty list of column names on the model (no duplicate names). Must not include the sensitive column. |
| `sensitive_column` | conditional | Model column name for the sensitive attribute. Omit when the test is declared under `columns:`; then dbt supplies `column_name` and that column is used as the sensitive attribute. |
| `l` | yes | Minimum distinct sensitive count per QI tuple; integer ≥ 1 (practice often uses l ≥ 2). |
| `sample_limit` | no | Max rows returned on failure; default `50`. |
| `column_name` | no | Set by dbt when the test is attached at column level; used as the sensitive column when `sensitive_column` is omitted. |

**Compiled SQL (tests and debugging)**

`dbt_data_privacy.l_diversity_test_query_sql(model, quasi_identifiers, sensitive_column, l, sample_limit)` returns the same SQL string the generic test executes after validation. The `sensitive_column` argument must be the **resolved** column name string (as in SQL). It dispatches to BigQuery-specific SQL only.

**Example (model-level `data_tests`)**

When this package is installed as a dependency, qualify the test with the package name (for example `dbt_data_privacy.l_diversity` in YAML).

```yaml
models:
  - name: my_release_model
    data_tests:
      - dbt_data_privacy.l_diversity:
          arguments:
            quasi_identifiers: [age_band, gender, postal_sector]
            sensitive_column: diagnosis_code
            l: 3
            sample_limit: 20
```

**Example (column-level `data_tests`)**

```yaml
columns:
  - name: diagnosis_code
    data_tests:
      - dbt_data_privacy.l_diversity:
          arguments:
            quasi_identifiers: [age_band, gender, postal_sector]
            l: 3
```

## Data Loss Prevention

COMING SOON
