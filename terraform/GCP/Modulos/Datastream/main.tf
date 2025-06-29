resource "google_datastream_connection_profile" "postgresql_source" {
  display_name          = "datastream-rds"
  location              = "europe-southwest1"
  connection_profile_id = "datastream-rds"
  project               = "flowing-scholar-463011-d0"

  postgresql_profile {
    hostname = split(":", aws_db_instance.main.endpoint)[0]
    username = var.db_username
    password = var.db_password
    database = var.db_name
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

resource "null_resource" "configure_datastream" {
  depends_on = [aws_db_instance.main]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]

    command = <<-EOT
      $env:PGPASSWORD="${var.db_password}";

      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "CREATE PUBLICATION datastream_publication FOR ALL TABLES;"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "SELECT PG_CREATE_LOGICAL_REPLICATION_SLOT('datastream_slot', 'pgoutput');"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "CREATE USER ${var.datastream_username} WITH ENCRYPTED PASSWORD '${var.datastream_password}';"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "GRANT rds_replication TO ${var.datastream_username};"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "GRANT USAGE ON SCHEMA public TO ${var.datastream_username};"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO ${var.datastream_username};"
      psql -h "${split(":", aws_db_instance.main.endpoint)[0]}" -U "${var.db_username}" -d "${var.db_name}" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO ${var.datastream_username};"

      Remove-Item Env:PGPASSWORD
    EOT
  }
}
