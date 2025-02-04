
#For DEV and PRD only
resource "dbt_cloud_project" "dbt-cloud-project-dev" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  name = upper("${var.env}${var.dbt_cloud_project_prefix}_${var.dbt_cloud_project_name}")
}

#For DEV and PRD only
resource "dbt_cloud_connection" "dbt-cloud-connection" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  name = var.dbt_cloud_connection_name
  project_id = dbt_cloud_project.dbt-cloud-project-dev.id
  type = "snowflake"
  account = var.dbt_cloud_snowflake_account
  database = upper("${var.env}_${var.dbt_cloud_project}")
  role = var.dbt_cloud_snowflake_role
  warehouse = var.dbt_cloud_snowflake_warehouse
  #depends_on = [ dbt_cloud_project.dbt-cloud-project ]
}
#
#For DEV and PRD only
resource "dbt_cloud_project_connection" "dbt-cloud-project-connection" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  connection_id = dbt_cloud_connection.dbt-cloud-connection.connection_id
  project_id = dbt_cloud_project.dbt-cloud-project-dev.id
}
#For DEV, and PRD
resource "dbt_cloud_repository" "azure-devops-repo" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  project_id = dbt_cloud_project.dbt-cloud-project-dev.id
  remote_url = "git::put git url"

}
#For DEV, and PRD
resource "dbt_cloud_project_repository" "azure-devops-proj-repo" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  project_id = dbt_cloud_project.dbt-cloud-project-dev.id
  repository_id = dbt_cloud_repository.azure-devops-repo.repository_id
}


#For DEV, SIT, UAT, NFT and PRD
resource "dbt_cloud_snowflake_credential" "dbt-cloud-snowflake-credential" {
count = var.env == "dev" || var.env == "prd" ? 1 : 0
  project_id  = dbt_cloud_project.dbt-cloud-project-dev.id
  auth_type   = "password"
  num_threads = 4
  schema      = upper("ato_${var.dbt_cloud_project_name}_staging")
  user        = var.dbt_cloud_snowflake_user
  password    = var.dbt_cloud_snowflake_password
  database    = upper("${var.env}_${var.dbt_cloud_project}")
  role        = var.dbt_cloud_snowflake_role
  warehouse   = var.dbt_cloud_snowflake_warehouse
}
