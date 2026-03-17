import nox
import os
from contextlib import contextmanager

# Nox options
nox.options.sessions = ["dev_unit_tests"]
nox.options.default_venv_backend = "uv"

PYTHON_VERSIONS = ["3.10", "3.11", "3.12"]
DBT_VERSION_MAP = {
    "1.10": {
        "uv_group": "dbt-core-1-10",
        "description": "dbt-core v1.10",
    },
    "1.11": {
        "uv_group": "dbt-core-1-11",
        "description": "dbt-core v1.11",
    },
}

def get_dataset_name(session, dbt_version):
    """Generate a unique BigQuery dataset name for the session."""
    py_ver = session.python.replace(".", "")
    dbt_ver = dbt_version.replace(".", "")
    # Add a suffix if running in CI to avoid any possible collisions
    suffix = os.environ.get("GITHUB_RUN_ID", "")
    if suffix:
        return f"dbt_dp_py{py_ver}_dbt{dbt_ver}_{suffix}"
    return f"dbt_dp_py{py_ver}_dbt{dbt_ver}"

def run_deps(session, env):
    """Install dbt dependencies."""
    session.log("Installing dbt dependencies")
    session.run(
        "dbt", "deps",
        "--profiles-dir", "profiles",
        "--target", "bigquery",
        env=env,
        external=True
    )

def run_cleanup(session, dataset_name, vars_path):
    """Drop the temporary dataset."""
    session.log(f"Cleaning up dataset: {dataset_name}")

    with open(vars_path, "r", encoding="utf-8") as f:
        vars_content = f.read()

    session.run(
        "dbt", "run-operation", "drop_dataset",
        "--profiles-dir", "profiles",
        "--target", "bigquery",
        "--vars", vars_content,
        env={"DBT_DATASET": dataset_name},
        external=True
    )

@contextmanager
def dbt_test_env(session, dbt_version):
    """Context manager to setup and cleanup dbt test environment."""
    if dbt_version not in DBT_VERSION_MAP:
        session.error(f"Unsupported dbt version: {dbt_version}")

    version_info = DBT_VERSION_MAP[dbt_version]
    session.install("--group", version_info["uv_group"])

    dataset_name = get_dataset_name(session, dbt_version)
    env = {"DBT_DATASET": dataset_name}

    run_deps(session, env)

    vars_path = "resources/vars/vars-bigquery.basic.yml"
    try:
        yield {"env": env, "vars_path": vars_path}
    finally:
        run_cleanup(session, dataset_name, vars_path)

@nox.session(python="3.12")
def dev_unit_tests(session):
    """Quickly run unit tests with the latest versions."""
    latest_version = list(DBT_VERSION_MAP.keys())[-1]
    unit_tests(session, latest_version)

@nox.session(python="3.12")
def dev_integration_tests(session):
    """Quickly run integration tests with the latest versions."""
    latest_version = list(DBT_VERSION_MAP.keys())[-1]
    integration_tests(session, latest_version)

@nox.session(python=PYTHON_VERSIONS)
@nox.parametrize("dbt_version", list(DBT_VERSION_MAP.keys()))
def unit_tests(session, dbt_version):
    """Run unit tests with specified dbt-core version."""
    with dbt_test_env(session, dbt_version) as test_env:
        session.run(
            "bash", "run_unit_tests.sh",
            "--target", "bigquery",
            "--vars-path", test_env["vars_path"],
            env=test_env["env"],
            external=True
        )

@nox.session(python=PYTHON_VERSIONS)
@nox.parametrize("dbt_version", list(DBT_VERSION_MAP.keys()))
def integration_tests(session, dbt_version):
    """Run integration tests with specified dbt-core version."""
    with dbt_test_env(session, dbt_version) as test_env:
        env = test_env["env"]
        vars_path = test_env["vars_path"]

        # Modern generation and build
        session.run(
            "bash", "scripts/generate_secured_models.sh",
            "--target", "bigquery",
            "--vars-path", vars_path,
            "--modern-schema",
            env=env,
            external=True
        )
        session.run(
            "bash", "run_integration_tests.sh",
            "--target", "bigquery",
            "--vars-path", vars_path,
            env=env,
            external=True
        )

        # Legacy generation and build
        session.run(
            "bash", "scripts/generate_secured_models.sh",
            "--target", "bigquery",
            "--vars-path", vars_path,
            env=env,
            external=True
        )
        session.run(
            "bash", "run_integration_tests.sh",
            "--target", "bigquery",
            "--vars-path", vars_path,
            env=env,
            external=True
        )

@nox.session(python=PYTHON_VERSIONS)
@nox.parametrize("dbt_version", list(DBT_VERSION_MAP.keys()))
def setup_dbt_env(session, dbt_version):
    """Setup a virtual environment for a specific dbt version and output its bin path."""
    if dbt_version not in DBT_VERSION_MAP:
        session.error(f"Unsupported dbt version: {dbt_version}")

    version_info = DBT_VERSION_MAP[dbt_version]
    session.install("--group", version_info["uv_group"])
    print(f"BIN_PATH={session.bin}")

@nox.session(python=PYTHON_VERSIONS)
def dbt_fusion_tests(session):
    """Placeholder for future dbt Fusion tests."""
    session.log("dbt Fusion tests are not yet implemented.")
