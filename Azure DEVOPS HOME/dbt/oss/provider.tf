provider "azurerm" {

  features {}
}
 
terraform {
  backend "azurerm" {}

  required_providers {
    dbt = {
      source  = "GtheSheep/dbt-cloud"
      version = "0.1.4"
    }
  }
}

provider "dbt" {

  account_id = "__DBT_ACCOUNT__"
  token  = "__DBT_TOKEN__"

  // optional, at exactly one must be set
  host_url = "__DBT_URL__"
}