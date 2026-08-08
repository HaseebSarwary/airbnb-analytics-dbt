from pathlib import Path

from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets

# Path to your dbt project (one folder up from this file's parent)
DBT_PROJECT_DIR = Path(__file__).parent.parent.parent.resolve()

# Path to the manifest.json file that dbt generates
# This file describes every model, source, and test in your project
DBT_MANIFEST_PATH = DBT_PROJECT_DIR / "target" / "manifest.json"


@dbt_assets(manifest=DBT_MANIFEST_PATH)
def airbnb_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    """Load all dbt models as Dagster assets."""
    yield from dbt.cli(["build"], context=context).stream()
