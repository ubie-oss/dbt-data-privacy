---
name: lint-and-fix
description: Automated linting and fixing loop using `make lint`. Use when you need to resolve linter violations across the codebase.
---

# Lint and Fix

## Purpose

This skill provides an autonomous loop to identify, fix, and verify linter violations in the codebase using the project's `make lint` command (which runs `pre-commit`).

## Loop Logic

1. **Identify**: Run `make lint` from the workspace root to list current violations.
2. **Analyze**: Examine the linter output to understand which files and rules are failing.
3. **Fix**: Apply targeted fixes for the identified violations.
    - Many linters in `pre-commit` (like `black`, `ruff`, `prettier`) can auto-fix issues.
    - If `pre-commit` auto-fixes files, review the changes.
    - If manual fixes are required, apply the minimum necessary change to resolve each error.
4. **Verify**: Re-run `make lint`.
    - If all checks pass: Termination.
    - If new or remaining failures exist: Analyze the failure and repeat the loop.

## Termination Criteria

- `make lint` exits with code 0 (all checks passed).
- Reached max iteration limit of 5 attempts.
- No progress being made (same errors persisting despite fix attempts).

## Examples

### Scenario: Fixing formatting and imports

1. `make lint` fails with `ruff` and `black` errors.
2. Agent runs `make lint` again (some linters auto-fix).
3. Agent reviews auto-fixed changes.
4. `make lint` passes.
