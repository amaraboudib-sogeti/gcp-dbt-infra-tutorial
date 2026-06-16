resource "google_service_account" "workflow_sa" {
  account_id = "workflow-sa"
  project    = var.project_id
}

resource "google_project_iam_member" "bq" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}

resource "google_project_iam_member" "storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.workflow_sa.email}"
}