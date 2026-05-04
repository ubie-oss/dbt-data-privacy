# dbt-data-privacy

This dbt package enables us to protect out customers' privacy on warehouse.

<!-- toc -->

- [Installation Instructions](#installation-instructions)
- [Codex](#codex)
- [Requirements](#requirements)
- [Supported warehouses](#supported-warehouses)
- [Generic tests](#generic-tests)
- [Macros](#macros)
  * [Pseudonymization](#pseudonymization)
  * [Code generation](#code-generation)

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

Custom generic data tests (**k_anonymity**, **l_diversity**), semantics, arguments, and YAML examples are documented in [docs/references/generic_tests.md](docs/references/generic_tests.md).

## Macros

### Pseudonymization

Hashing and related helpers (`sha256`, `sha512`, `extract_email_domain`) are documented in [docs/references/pseudonymization.md](docs/references/pseudonymization.md).

### Code generation

[Generate privacy-protected dbt models](./docs/generate_models.md)
