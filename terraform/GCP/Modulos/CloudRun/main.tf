resource "google_artifact_registry_repository" "repo-dp3" {
  location      = "europe-southwest1"
  repository_id = "repo-dp3"
  format        = "DOCKER"
  project       = "flowing-scholar-463011-d0"

}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = <<EOL
      docker build --platform linux/amd64 -t api "D:\EDEM\CLOUD\Data-Project-3\my_app\backend"
      docker tag api europe-southwest1-docker.pkg.dev/flowing-scholar-463011-d0/flowing-scholar-463011-d0-repo/api:latest
      docker push europe-southwest1-docker.pkg.dev/flowing-scholar-463011-d0/flowing-scholar-463011-d0-repo/api:latest
    EOL
  }
}

resource "google_cloud_run_service" "default" {
  name     = "api-service"
  location = "europe-southwest1"

  template {
    spec {
      service_account_name = google_service_account.cloud_run_service_account.email

      containers {
        image = "europe-southwest1-docker.pkg.dev/flowing-scholar-463011-d0/repo-dp3/api-service:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [null_resource.docker_build]
}

resource "null_resource" "access_api" {
  provisioner "local-exec" {
    command = <<EOL
      gcloud run services add-iam-policy-binding api-service --region=europe-southwest1 --member="allUsers" --role="roles/run.invoker" --project=flowing-scholar-463011-d0
    EOL
  }

  depends_on = [google_cloud_run_service.default]
}

resource "google_service_account" "cloud_run_service_account" {
  account_id   = "cloud-run-service-account"
  display_name = "Cloud Run Service Account"
  project      = "flowing-scholar-463011-d0" 
}