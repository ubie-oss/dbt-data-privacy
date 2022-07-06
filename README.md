# dbt-data-privacy
This dbt package enables us to protect out customers' privacy on warehouse.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Installation Instructions](#installation-instructions)
- [Requirements](#requirements)
- [Supported warehouses](#supported-warehouses)
- [Generic tests and macros](#generic-tests-and-macros)
  - [Generic tests](#generic-tests)
    - [Data Loss Prevention](#data-loss-prevention)
  - [Macros](#macros)
    - [Pseudonymization](#pseudonymization)
      - [`sha256`](#sha256)
      - [`sha512`](#sha512)
      - [`extract_email_domain`](#extract_email_domain)
    - [Code generation](#code-generation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Installation Instructions
COMING SOON

## Requirements
- dbt-core: 1.1.0 or later

## Supported warehouses
We support only BigQuery at the moment.
But, the implementation can be extended to other warehouses by following the manner of dbt package development.

- BigQuery

## Generic tests

### Data Loss Prevention
COMING SOON

## Macros

### Pseudonymization

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

### Code generation
COMING SOON
