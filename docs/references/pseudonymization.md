# Pseudonymization macros (dbt-data-privacy)

Package overview: [README](../../README.md). For code-generated privacy models, see [Generate privacy-protected dbt models](../generate_models.md).

## `sha256`

Computes the hash of the input using the SHA-256 algorithm.

**Usage:**

```yaml
SELECT
  {{ dbt_data_privacy.sha256("column_a") }} AS column_a,
```

## `sha512`

Computes the hash of the input using the SHA-512 algorithm.

**Usage:**

```yaml
SELECT
  {{ dbt_data_privacy.sha512("column_a") }} AS column_a,
```

## `extract_email_domain`

BigQuery implementation: if the expression looks like an email (contains `@`), returns the substring **before** the first `@`; otherwise returns the expression unchanged. (Despite the macro name, the shipped SQL does not return the domain part after `@`.)

**Usage:**

```yaml
SELECT
  {{ dbt_data_privacy.extract_email_domain("email_column") }} AS email_column,
```
