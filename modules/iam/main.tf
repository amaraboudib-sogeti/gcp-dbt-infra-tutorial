resource "google_bigquery_dataset" "bronze" {
  dataset_id = "bronze"
}

resource "google_bigquery_dataset" "silver" {
  dataset_id = "silver"
}

resource "google_bigquery_dataset" "gold" {
  dataset_id = "gold"
}

# ✅ ingestion auto (external tables)
resource "google_bigquery_table" "users_ext" {
  dataset_id = google_bigquery_dataset.bronze.dataset_id
  table_id   = "users_ext"

  external_data_configuration {
    source_uris   = ["gs://${var.raw_bucket}/users.csv"]
    source_format = "CSV"
    autodetect    = true
  }
}

resource "google_bigquery_table" "connections_ext" {
  dataset_id = google_bigquery_dataset.bronze.dataset_id
  table_id   = "connections_ext"

  external_data_configuration {
    source_uris   = ["gs://${var.raw_bucket}/users_connections.csv"]
    source_format = "CSV"
    autodetect    = true
  }
}