---
name: verify-generate-models-lifecycle
description: TLA+ model and real-script replay for the generate-models lifecycle. Checks that a run which reports success never leaves a stale generated model that selects raw email, or a file the config does not produce. Use when changing .github/actions/generate-models, generate_models.sh, the delete or regenerate steps, delete_before, the generate_privacy_protected_models macro, or the model on/off or email-level config that drives generated files.
---

# Verify the generate-models lifecycle

## What it checks

The generate-models action deletes the generated model files, then regenerates them from the current config. Before the fix, the script ran its delete and generate steps under `set +Eeuo pipefail`, so a failure in either step was hidden and the run exited 0. The fix removes those wrappers, so any failure fails the run. The script also rejects `delete_before` values other than `1` before it changes any file.

The model in `formal/generate_models/GenerateModels.tla` covers one generated model, one path, and one email column. A run has four outcomes: delete ok or failed, crossed with generation ok or failed. A config commit can turn the model on or off, or change the email level.

Rules, in plain words:

- **NoRawEmailAfterSuccess.** A run that reports success never leaves a file that holds the raw email when the config drops the email.
- **NoOrphanAfterSuccess.** A run that reports success never leaves a file the current config does not produce.

Scope: a config change that moves the model to another path is not modeled. A move leaves the old file behind the same way that turning the model off does. Hashed levels are not modeled. The script rejects `delete_before` values other than `1`, so the model always deletes first. The two faults are independent.

## Files

- Model: `formal/generate_models/GenerateModels.tla`
- Current script config: `formal/generate_models/current.cfg`. Mode `failfast`, which matches `generate_models.sh` after the fix.
- Pre-fix config: `formal/generate_models/before-fix.cfg`. Mode `silent`, the script before the fix. It stays as the record of the bug.
- Reader labels: `formal/generate_models/view.mjs`
- Real-script replay: `formal/generate_models/replay_silent_failure.sh`

## Run it

1. Run the model with `/statechart`. Use `GenerateModels.tla`, the config file for the mode you want to check, and `view.mjs`. Write the output to a new folder outside the repo. Use `current.cfg` for the current script, and `before-fix.cfg` to show the bug before the fix. The first run installs TLC and Java with mise, which needs the network.
2. Run the replay from the repo root: `formal/generate_models/replay_silent_failure.sh`. It runs the real `generate_models.sh` with a fake `dbt`. `dbt ls` fails, and generation returns no models. It exits 0 with `RESULT: no silent stale model on this path` on the fixed script. It exits 1 with `RESULT: bug reproduced` only if the silent failure comes back.

Expected results now:

- `current.cfg`: both rules hold. `TypeOK` holds, and the statechart tool also reports `NoDeadlock`.
- `before-fix.cfg`: both rules break. The shortest path for each rule is three steps. First, a run whose `dbt ls` fails writes the raw email, and reports ok. Second, the config turns the model off or drops the email. Third, a run whose `dbt ls` fails and whose generation fails reports ok, and the old raw file stays.
- The replay on the fixed script: exit 0, `RESULT: no silent stale model on this path`.

## Read a failure

A broken rule shows a shortest path in the report. Read it as steps of the real run:

1. Confirm that each step exists in the script. `dbt ls` is the delete step. `run-operation generate_privacy_protected_models` is the generate step. The step that says "reports ok" is the final exit of `generate_models.sh`.
2. If the model's path has a step that the script cannot take, the model is wrong. Fix the model, and say so.
3. If the script can take every step, the bug is real. Report it with the path in these words, and do not change the rule to make it pass.

Use the replay to confirm the real code, as a live repro. On the fixed script, exit 0 with `no silent stale model` is expected. If the replay exits 1 with `bug reproduced`, the silent failure is back. Investigate the script before you change the model.

## Keep it in step with the code

Covered code:

- `.github/actions/generate-models/generate_models.sh`, in the delete step and the generate loop. Their exit handling is the part the model describes.
- `.github/actions/generate-models/action.yml`, for the inputs that reach the script. The script accepts only `delete_before` set to `1`.
- `macros/public/generate_privacy_protected_models.sql`, which produces the models the script writes.

After a change to any covered file, rerun the model and the replay.
