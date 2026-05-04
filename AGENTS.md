# AGENTS.md

## Repository Overview

- This repository is a dbt package for privacy-protecting transformations and macros.
- BigQuery is the only supported warehouse today.
- Prefer minimal, focused changes that preserve existing macro behavior and test coverage.

## Working Rules

- Read the nearest `README.md`, relevant macro files, and existing tests before editing behavior.
- Keep changes aligned with existing dbt and SQL style in the repository.
- Do not modify unrelated generated or fixture data unless the task requires it.
- If public behavior changes, update the relevant documentation in `README.md` or `docs/`.

## Testing

- For custom **generic data tests** (test blocks, dispatch, integration fixtures), follow [`.claude/skills/dbt-custom-generic-test/SKILL.md`](.claude/skills/dbt-custom-generic-test/SKILL.md).
- Run tests from the `integration_tests` directory.
- For most code changes, run `make run-unit-tests`.
- When behavior changes affect generated SQL or dbt execution flows, also run `make run-integration-tests` when the environment is available.

## Repository-Specific Notes

- Keep `.cursor/sandbox.json` aligned with the sandbox section of `.claude/settings.json` when either file changes.
- GitHub workflow changes should stay consistent with the commands and paths used by this repository's Makefiles and test scripts.
