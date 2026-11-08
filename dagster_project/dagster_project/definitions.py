from pathlib import Path

from dagster import Definitions, load_assets_from_modules
from dagster_dbt import DbtCliResource

from dagster_project import assets  # noqa: TID252


# Path to your dbt project (one folder up from dagster_project/)
DBT_PROJECT_DIR = Path(__file__).parent.parent.parent.resolve()

all_assets = load_assets_from_modules([assets])

defs = Definitions(
    assets=all_assets,
    resources={
        "dbt": DbtCliResource(project_dir=str(DBT_PROJECT_DIR)),
    },
)