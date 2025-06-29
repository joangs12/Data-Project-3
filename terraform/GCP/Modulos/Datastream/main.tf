resource "google_datastream_connection_profile" "postgresql_source" {
  display_name          = "datastream-rds"
  location              = "europe-southwest1"
  connection_profile_id = "datastream-rds"
  project               = "flowing-scholar-463011-d0"

  postgresql_profile {
    hostname = split(":", aws_db_instance.main.endpoint)[0]
    username = "postgres"
    password = "edem2425"
    database = "postgres-db"
    port     = 5432
  }

}

resource "google_datastream_connection_profile" "bigquery_destination" {
  display_name          = "datastream-bigquery-destination"
  location              = "europe-southwest1"
  connection_profile_id = "datastream-bigquery-destination"
  project               = "flowing-scholar-463011-d0"

  bigquery_profile {}

}

resource "google_datastream_stream" "postgresql_to_bigquery" {
  display_name = "datastream-stream"
  location     = "europe-southwest1"
  stream_id    = "datastream-stream"
  project      = "flowing-scholar-463011-d0"

  source_config {
    source_connection_profile = google_datastream_connection_profile.postgresql_source.id
    postgresql_source_config {
      include_objects {
        postgresql_schemas {
          schema = "public"
          postgresql_tables {
            table = "products"
          }
        }
      }
      publication = "datastream_publication"
      replication_slot = "datastream_slot"
      max_concurrent_backfill_tasks = 12
    }
  }

  destination_config {
    destination_connection_profile = google_datastream_connection_profile.bigquery_destination.id
    bigquery_destination_config {
      single_target_dataset {
        dataset_id = "flowing-scholar-463011-d0:moviesdb"
      }
    }
  }

}

resource "null_resource" "start_datastream" {
  triggers = {
    stream_id = google_datastream_stream.postgresql_to_bigquery.name
  }

  provisioner "local-exec" {
    command = "gcloud datastream streams update datastream-stream --location=europe-southwest1 --state=RUNNING --update-mask=state --quiet"
  }

}