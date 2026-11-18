------------------------------- MODULE GenerateModels -------------------------------
(*
Model of the generate-models lifecycle in
.github/actions/generate-models/generate_models.sh.

One generated model, written to one path, with one email column.
A run does, in order:
  1. delete the generated file (dbt ls, then rm). Only delete_before on is modeled.
  2. run generate_privacy_protected_models and write the file for the current config
  3. exit

Each step can fail. A run has four outcomes: delete ok or failed, crossed with
generation ok or failed. A config commit never happens during a run, so a run is
one atomic step here.

Mode = "silent"    the current script. Failures are swallowed (set +e), and the script
                   always exits 0, so every run reports "ok".
Mode = "failfast"  a reference variant, not the current code. Any failure stops the run
                   and it reports "failed". It is not applied to the repo; it shows what
                   the check accepts.

Scope and simplifications:
- A config change that moves the model to another path is not modeled. A move leaves
  the old file behind exactly as turning the model off does, so the same rules apply.
- A file holds either the raw email ("Raw") or no email ("Dropped"). Hashed levels are
  not modeled.
- The two faults are independent, which is conservative for the "silent" mode.
*)
EXTENDS TLC

CONSTANT Mode

FileState == {"none", "Raw", "Dropped"}
Sensitive == {"Raw", "Dropped"}

VARIABLES cfgEnabled, cfgSensitive, file, status

vars == <<cfgEnabled, cfgSensitive, file, status>>

\* The status a run reports after a failure. The current script reports ok.
Reported == IF Mode = "silent" THEN "ok" ELSE "failed"

TypeOK ==
  /\ cfgEnabled \in BOOLEAN
  /\ cfgSensitive \in Sensitive
  /\ file \in FileState
  /\ status \in {"none", "ok", "failed"}

Init ==
  /\ cfgEnabled \in BOOLEAN
  /\ cfgSensitive \in Sensitive
  /\ file = "none"
  /\ status = "none"

\* A config commit turns the model on or off, or changes the email level.
\* A status only describes the config it ran against, so a config change clears it.
ToggleModel ==
  /\ cfgEnabled' = ~cfgEnabled
  /\ status' = "none"
  /\ UNCHANGED <<cfgSensitive, file>>

Reclassify ==
  /\ cfgSensitive' = IF cfgSensitive = "Raw" THEN "Dropped" ELSE "Raw"
  /\ status' = "none"
  /\ UNCHANGED <<cfgEnabled, file>>

\* Both steps succeed. The file is replaced, or removed when the model is off.
RunOk ==
  /\ file' = IF cfgEnabled THEN cfgSensitive ELSE "none"
  /\ status' = "ok"
  /\ UNCHANGED <<cfgEnabled, cfgSensitive>>

\* dbt ls fails, then generation succeeds. The current script keeps the old file,
\* then writes the new one over it.
DeleteFailsGenOk ==
  /\ file' = IF Mode = "silent" /\ cfgEnabled THEN cfgSensitive ELSE file
  /\ status' = Reported
  /\ UNCHANGED <<cfgEnabled, cfgSensitive>>

\* dbt ls succeeds, then generation fails. The file is already deleted.
DeleteOkGenFails ==
  /\ file' = "none"
  /\ status' = Reported
  /\ UNCHANGED <<cfgEnabled, cfgSensitive>>

\* dbt ls fails and generation fails. The old file stays.
DeleteFailsGenFails ==
  /\ file' = file
  /\ status' = Reported
  /\ UNCHANGED <<cfgEnabled, cfgSensitive>>

Next ==
  \/ ToggleModel
  \/ Reclassify
  \/ RunOk
  \/ DeleteFailsGenOk
  \/ DeleteOkGenFails
  \/ DeleteFailsGenFails

Spec == Init /\ [][Next]_vars

\* Rule 1: a run that reports success never leaves a file that holds the raw email
\* when the config drops the email.
NoRawEmailAfterSuccess ==
  status = "ok" => ~(cfgSensitive = "Dropped" /\ file = "Raw")

\* Rule 2: a run that reports success never leaves a file the current config does not produce.
NoOrphanAfterSuccess ==
  status = "ok" => (file /= "none" => cfgEnabled)

=============================================================================
