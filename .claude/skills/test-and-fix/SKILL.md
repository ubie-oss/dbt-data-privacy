---
name: test-and-fix
description: Autonomously run tests, analyze failures, and fix them in the `integration_tests` directory.
---

# Test and Fix

## Purpose

This skill provides an autonomous loop to identify, analyze, and fix test failures within the `integration_tests` directory using the project's `make` commands.

## Loop Logic

1. **Identify**: Run tests from the `integration_tests` directory.
    - Agent must make sure what type of test the user wants to run (unit or integration), becaues it takes a long time to run all tests.
    - `make test`: Runs all unit and integration tests (both dbt-core and dbt-fusion). This is the standard command for a full verification.
    - `make run-unit-tests`: Runs all unit tests (both core and fusion).
    - `make run-integration-tests`: Runs all integration tests (both core and fusion).
    - For targeted debugging, use granular sub-targets:
        - `make run-unit-tests-core` / `make run-unit-tests-fusion`
        - `make run-integration-tests-core` / `make run-integration-tests-fusion`
2. **Analyze**: Examine the test output and logs to understand which tests are failing.
    - Check the `logs/dbt.log` in `integration_tests/` for detailed dbt execution logs.
    - For macro failures, inspect the generated SQL and compare it with expected BigQuery syntax.
    - Note: BigQuery is the only supported warehouse in this repository.
3. **Plan Fix**: Before applying any fix, create an **MVP scaffold** that delivers the smallest valuable slice of the fix.
    - Define acceptance criteria for the fix.
    - Create a plan in memory to track the fix progress.
4. **Execute & Test**:
    - Implement the MVP scaffold.
    - Run the relevant tests immediately (e.g., `cd integration_tests && make run-unit-tests-core`).
    - Only add details and enhancements after the scaffold tests pass.
5. **Verify**: Re-run the tests.
    - If all checks pass: Termination.
    - If new or remaining failures exist: Analyze the failure and repeat the loop.

## Termination Criteria

- All relevant tests exit with code 0 (all checks passed).
- Reached max iteration limit of 5 attempts.
- No progress being made (same errors persisting despite fix attempts).

## Examples

### Scenario: Fixing a failing macro unit test

1. Agent runs `make test` and identifies a failure in `test_macros` for dbt-core.
2. Agent analyzes the output and finds that `macro_a` is returning incorrect SQL for BigQuery.
3. Agent creates a plan in memory.
4. Agent implements a minimal fix for `macro_a` to address the specific failure.
5. Agent runs `make run-unit-tests-core` to quickly verify the fix.
6. The test passes. Agent runs `make test` to ensure no regressions across the entire suite.
7. The test passes. Agent marks the task as complete.
