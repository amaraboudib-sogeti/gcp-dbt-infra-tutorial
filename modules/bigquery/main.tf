resource "google_bigquery_dataset" "bronze" {
  dataset_id = "bronze"
  location   = var.region
  project    = var.project_id
}

resource "google_bigquery_dataset" "silver" {
  dataset_id = "silver"
  location   = var.region
  project    = var.project_id
}

resource "google_bigquery_dataset" "gold" {
  dataset_id = "gold"
  location   = var.region
  project    = var.project_id
}

# ✅ External table users
resource "google_bigquery_table" "users_ext" {
  dataset_id = google_bigquery_dataset.bronze.dataset_id
  table_id   = "users_ext"
  project    = var.project_id

  external_data_configuration {
    source_uris   = ["gs://${var.raw_bucket}/users.csv"]
    source_format = "CSV"
    autodetect    = true
  }
}

# ✅ External table connections
resource "google_bigquery_table" "connections_ext" {
  dataset_id = google_bigquery_dataset.bronze.dataset_id
  table_id   = "connections_ext"
  project    = var.project_id

  external_data_configuration {
    source_uris   = ["gs://${var.raw_bucket}/users_connections.csv"]
    source_format = "CSV"
    autodetect    = true
  }
}