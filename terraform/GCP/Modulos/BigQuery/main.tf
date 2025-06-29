provider "google" {
    project = "flowing-scholar-463011-d0"
    region  = "europe-southwest1"
    zone    = "europe-southwest1-a"
  
}


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
  {"name": "title", "type": "STRING", "mode": "REQUIRED"},
  {"name": "genre", "type": "STRING"},
  {"name": "release_year", "type": "INTEGER"},
]
EOF
}