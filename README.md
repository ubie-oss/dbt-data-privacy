# dbt-data-privacy
This dbt package enables us to protect out customers' privacy on warehouse.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Supported warehouses
We support only BigQuery at the moment.
But, the implementation can be extended to other warehouses by following the manner of dbt package development.

- BigQuery

## Generic tests and macros

### Generic tests

#### Data Loss Prevention
COMING SOON

### Macros

#### Pseudonymization

#### `sha256`
Computes the hash of the input using the SHA-256 algorithm. 

**Usage:**
```yaml
SELECT
  {{ dbt_data_privacy.sha256("column_a") }} AS column_a,
```

#### `sha512`
Computes the hash of the input using the SHA-512 algorithm. 

**Usage:**
```yaml
SELECT
  {{ dbt_data_privacy.sha512("column_a") }} AS column_a,
```

#### `extract_email_domain`
Computes the hash of the input using the SHA-512 algorithm.

**Usage:**
```yaml
SELECT
  {{ dbt_data_privacy.extract_email_domain("email_column") }} AS email_column,
```

#### Code generation
COMING SOON
