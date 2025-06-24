resource "google_datastream_connection_profile" "source" {
    display_name          = "Postgresql Source"
    location              = "europe-west1"
    connection_profile_id = "source-profile"

    postgresql_profile {
        hostname = "postgres-db.cr4ei2qco23l.eu-central-1.rds.amazonaws.com"
        port     = 5432
        username = "postgresdb"
        password = "postgres"
        database = "edem2425"
    }
}

# resource "google_storage_bucket" "bucket" {
#   name                        = "my-bucket"
#   location                    = "EU"
#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket_iam_member" "viewer" {
#     bucket = google_storage_bucket.bucket.name
#     role   = "roles/storage.objectViewer"
#     member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-datastream.iam.gserviceaccount.com"
# }

# resource "google_storage_bucket_iam_member" "creator" {
#     bucket = google_storage_bucket.bucket.name
#     role   = "roles/storage.objectCreator"
#     member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-datastream.iam.gserviceaccount.com"
# }

# resource "google_storage_bucket_iam_member" "reader" {
#     bucket = google_storage_bucket.bucket.name
#     role   = "roles/storage.legacyBucketReader"
#     member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-datastream.iam.gserviceaccount.com"
# }

# resource "google_kms_crypto_key_iam_member" "key_user" {
#     crypto_key_id = "kms-name"
#     role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#     member        = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-datastream.iam.gserviceaccount.com"
# }

resource "google_datastream_connection_profile" "destination" {
    display_name          = "BigQuery Destination"
    location              = "europe-southwest1"
    connection_profile_id = "destination-profile"

    bigquery_profile {
    }
}

resource "google_datastream_stream" "default"  {
    display_name = "Postgres to BigQuery"
    location     = "europe-southwest1"
    stream_id    = "my-stream"
    desired_state = "RUNNING"

    source_config {
        source_connection_profile = google_datastream_connection_profile.source.id
        postgresql_source_config {
            max_concurrent_backfill_tasks = 12
            publication      = "publication"
            replication_slot = "replication_slot"
            include_objects {
                postgresql_schemas {
                    schema = "schema"
                    postgresql_tables {
                        table = "table"
                        postgresql_columns {
                            column = "column"
                        }
                    }
                }
            }
            exclude_objects {
                postgresql_schemas {
                    schema = "schema"
                    postgresql_tables {
                        table = "table"
                        postgresql_columns {
                            column = "column"
                        }
                    }
                }
            }
        }
    }

    destination_config {
        destination_connection_profile = google_datastream_connection_profile.destination.id
        bigquery_destination_config {
            data_freshness = "900s"
            source_hierarchy_datasets {
                dataset_template {
                   location = "europe-southwest1"
                }
            }
        }
    }

    backfill_all {
        postgresql_excluded_objects {
            postgresql_schemas {
                schema = "schema"
                postgresql_tables {
                    table = "table"
                    postgresql_columns {
                        column = "column"
                    }
                }
            }
        }
    }
}