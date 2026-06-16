module "gcs" {
  source     = "../../modules/gcs"
  project_id = var.project_id
  region     = var.region
}

module "bigquery" {
  source     = "../../modules/bigquery"
  project_id = var.project_id
  region     = var.region
  raw_bucket = module.gcs.raw_bucket
}

module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id
}

module "workflows" {
  source          = "../../modules/workflows"
  project_id      = var.project_id
  region          = var.region
  service_account = module.iam.workflow_sa_email
}