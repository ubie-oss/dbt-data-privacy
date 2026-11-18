#!/usr/bin/env bash
# Replays the silent-failure path of the generate-models lifecycle against the real script.
#
# Fault: `dbt ls` fails, so the delete step deletes nothing.
# Config: the model is off, so generation writes no file.
# A stale raw-email model file is left in place from an earlier run.
#
# Exit 1 when the run reports success and the stale file is still there (the bug).
# Exit 0 when that does not happen.
#
# Usage: replay_silent_failure.sh [path/to/generate_models.sh]
set -u

if ! command -v jq >/dev/null 2>&1; then
  echo "RESULT: jq is required by generate_models.sh" >&2
  exit 2
fi

here="$(cd "$(dirname "$0")" && pwd)"
script="${1:-${here}/../../.github/actions/generate-models/generate_models.sh}"
work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

mkdir -p "${work}/bin" "${work}/models/db/schema/alias"

# Fake dbt: `ls` fails, and generation returns no models.
cat >"${work}/bin/dbt" <<'EOF'
#!/bin/bash
case "$*" in
  *" ls "*) echo "simulated dbt ls failure" >&2; exit 1 ;;
  *run-operation*) echo "[]" ;;
  *) exit 0 ;;
esac
EOF
chmod +x "${work}/bin/dbt"

stale="${work}/models/db/schema/alias/m.sql"
echo "select email from raw_source" >"${stale}"

PATH="${work}/bin:${PATH}" bash "${script}" \
  --dbt-models-dir "${work}/models" \
  --delete-before 1 \
  --verbose 0 >"${work}/run.log" 2>&1
code=$?

leftover="no"
if [[ -f "${stale}" ]]; then leftover="yes"; fi

echo "script exit code: ${code}"
echo "stale raw-email model left behind: ${leftover}"
if [[ "${code}" -eq 0 && "${leftover}" == "yes" ]]; then
  echo "RESULT: bug reproduced, the run reports success with a stale raw-email model"
  exit 1
fi
echo "RESULT: no silent stale model on this path"
