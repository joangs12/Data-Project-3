provider "google" {
    project = "flowing-scholar-463011-d0"
    region  = "europe-southwest1"
    zone    = "europe-southwest1-a"
  
}

# resource "google_service_account" "bigquery_sa" {
#   account_id   = "bigquery-sa"
#   display_name = "BigQuery Service Account"
#   project      = var.project_id
# }

# resource "google_project_iam_member" "bigquery_sa_member" {
#   project = var.project_id
#   role    = "roles/bigquery.admin"
#   member  = "serviceAccount:${google_service_account.bigquery_sa.email}"
# }

resource "google_bigquery_dataset" "emergencia-eventos" {
  dataset_id  = "moviesdb"
  project     = "flowing-scholar-463011-d0"
  location    = "europe-southwest1"
}

resource "google_bigquery_table" "emergencias" {
  dataset_id = google_bigquery_dataset.emergencia-eventos.dataset_id
  table_id   = "movies"

  schema = <<EOF
[
  {"name": "id", "type": "INTEGER", "mode": "REQUIRED"},
  {"name": "title", "type": "STRING", "mode": "REQUIRED"},
  {"name": "director", "type": "STRING"},
  {"name": "genre", "type": "STRING"},
  {"name": "release_year", "type": "INTEGER"},
  {"name": "duration_minutes", "type": "INTEGER"},
  {"name": "rating", "type": "STRING"},
  {"name": "available", "type": "BOOLEAN"},
  {"name": "created_at", "type": "TIMESTAMP"}
]
EOF
}