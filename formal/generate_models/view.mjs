// Reader-facing labels for the GenerateModels TLA+ model.
// Read by the statechart command with --view. Keep these functions pure.

export const title = "generate-models: a config commit, then a run";

export const state = (v) => {
  const config = `${v.cfgEnabled ? "model on" : "model off"}, email ${
    v.cfgSensitive === "Raw" ? "raw" : "dropped"
  }`;
  const file = { none: "no file", Raw: "file holds raw email", Dropped: "file holds no email" }[v.file];
  const last = { none: "no run since commit", ok: "last run ok", failed: "last run failed" }[v.status];
  return `${config} / ${file} / ${last}`;
};

export const step = (action, from, to) => {
  switch (action) {
    case "ToggleModel":
      return from.cfgEnabled ? "config: turn model off" : "config: turn model on";
    case "Reclassify":
      return from.cfgSensitive === "Raw" ? "config: drop email" : "config: keep email raw";
    case "RunOk":
      return "run writes file, reports ok";
    case "DeleteFailsGenOk":
      return to.status === "failed" ? "dbt ls fails, run stops, reports failure" : "dbt ls fails, run writes file, reports ok";
    case "DeleteOkGenFails":
      return to.status === "failed" ? "generation fails, run reports failure" : "file deleted, generation fails, reports ok";
    case "DeleteFailsGenFails":
      return to.status === "failed" ? "dbt ls and generation fail, run reports failure" : "both fail, old file stays, reports ok";
    default:
      return null;
  }
};
