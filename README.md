# dbt-data-privacy

This dbt package enables us to protect out customers' privacy on warehouse.

<!-- toc -->

- [Installation Instructions](#installation-instructions)
- [Requirements](#requirements)
- [Supported warehouses](#supported-warehouses)
- [Generic tests](#generic-tests)
  - [Data Loss Prevention](#data-loss-prevention)
- [Macros](#macros)
  - [Pseudonymization](#pseudonymization)
    - [`sha256`](#sha256)
    - [`sha512`](#sha512)
    - [`extract_email_domain`](#extract_email_domain)
  - [Code generation](#code-generation)
    - [`generate_privacy_protected_models`](#generate_privacy_protected_models)

<!-- tocstop -->

## Installation Instructions

COMING SOON

## Codex

This repository includes shared Codex configuration in [`.codex/config.toml`](./.codex/config.toml) and project instructions in [`AGENTS.md`](./AGENTS.md).

These files provide a safe default sandbox, approval behavior, editor links for Cursor, and repository-specific guidance for testing and documentation updates.

The checked-in top-level configuration remains the default. For Codex CLI usage, the repository also defines two opt-in profiles:

- `fast`: `gpt-5.4` with low reasoning effort for smaller, iterative tasks
- `deep`: `gpt-5.4` with high reasoning effort for planning, review, and more complex changes

The repository also includes two read-only review subagents for Codex:

- `reviewer`: reviews dbt macros, SQL generation paths, workflows, and config changes for regressions and correctness risks
- `test_gap_checker`: reviews changes for missing unit, integration, and workflow coverage

Shared agent skills should be authored under [`.claude/skills`](./.claude/skills). [`.agents/skills`](./.agents/skills) is a compatibility symlink for other agent tooling and should not contain separate copies.

Example usage:

```bash
codex --profile fast
codex --profile deep
```

## Requirements

- dbt-core: 1.10 or later

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

[Generate privacy-protected dbt models](./docs/generate_models.md)
