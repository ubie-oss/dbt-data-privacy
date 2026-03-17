import nox
import os

# Nox options
nox.options.sessions = ["dev_unit_tests"]
nox.options.default_venv_backend = "uv"

PYTHON_VERSIONS = ["3.10", "3.11", "3.12"]
DBT_CORE_VERSIONS = ["1.10", "1.11"]

# Mapping of dbt versions to their specific dependencies
DBT_DEPENDENCIES = {
    "1.10": ["dbt-core>=1.10,<1.11", "dbt-bigquery>=1.10,<1.11"],
    "1.11": ["dbt-core>=1.11,<1.12", "dbt-bigquery>=1.11,<1.12"],
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

@nox.session(python="3.12")
def dev_unit_tests(session):
    """Quickly run unit tests with the latest versions."""
    unit_tests(session, "1.11")

@nox.session(python="3.12")
def dev_integration_tests(session):
    """Quickly run integration tests with the latest versions."""
    integration_tests(session, "1.11")

@nox.session(python=PYTHON_VERSIONS)
@nox.parametrize("dbt_version", DBT_CORE_VERSIONS)
def unit_tests(session, dbt_version):
    """Run unit tests with specified dbt-core version."""
    session.install(*DBT_DEPENDENCIES[dbt_version])
    dataset_name = get_dataset_name(session, dbt_version)
    env = {"DBT_DATASET": dataset_name}
    run_deps(session, env)

    vars_path = "resources/vars/vars-bigquery.basic.yml"
    try:
        session.run(
            "bash", "run_unit_tests.sh",
            "--target", "bigquery",
            "--vars-path", vars_path,
            env=env,
            external=True
        )
    finally:
        run_cleanup(session, dataset_name, vars_path)

@nox.session(python=PYTHON_VERSIONS)
@nox.parametrize("dbt_version", DBT_CORE_VERSIONS)
def integration_tests(session, dbt_version):
    """Run integration tests with specified dbt-core version."""
    session.install(*DBT_DEPENDENCIES[dbt_version])
    dataset_name = get_dataset_name(session, dbt_version)
    env = {"DBT_DATASET": dataset_name}
    run_deps(session, env)

    vars_path = "resources/vars/vars-bigquery.basic.yml"
    try:
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
    finally:
        run_cleanup(session, dataset_name, vars_path)

@nox.session(python=PYTHON_VERSIONS)
def dbt_fusion_tests(session):
    """Placeholder for future dbt Fusion tests."""
    session.log("dbt Fusion tests are not yet implemented.")
