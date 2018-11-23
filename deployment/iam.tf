# Enable GKE service
resource "google_project_service" "container-service-nsoc" {
  project = "${google_project.nsoc-host-demo-project.project_id}"
  service = "container.googleapis.com"
}

resource "google_project_service" "container-service-retail" {
  project = "${google_project.retail-service-demo-project.project_id}"
  service = "container.googleapis.com"
}

# Allow retail gke service to use nsoc subnet
resource "google_project_iam_binding" "retail-gke-project-access" {
  project = "${google_project.nsoc-host-demo-project.project_id}"
  role    = "roles/container.hostServiceAgentUser"

  members = [
    "serviceAccount:service-${google_project.retail-service-demo-project.number}@container-engine-robot.iam.gserviceaccount.com",
  ]

  depends_on = ["google_project_service.container-service-nsoc", "google_project_service.container-service-retail"]
}

# Allow Google service to use nsoc subnet
resource "google_compute_subnetwork_iam_member" "retail-cloud-subnet-access" {
  subnetwork = "${google_compute_subnetwork.retail-eu-subnetwork.name}"
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${google_project.retail-service-demo-project.number}@cloudservices.gserviceaccount.com"
  project    = "${google_project.nsoc-host-demo-project.project_id}"
  region     = "${google_compute_subnetwork.retail-eu-subnetwork.region}"

  depends_on = ["google_project_service.container-service-nsoc", "google_project_service.container-service-retail"]
}

resource "google_project_iam_binding" "retail-compute-network-access" {
  project = "${google_project.nsoc-host-demo-project.project_id}"
  role    = "roles/compute.networkUser"

  members = [
    "serviceAccount:service-${google_project.retail-service-demo-project.number}@container-engine-robot.iam.gserviceaccount.com",
  ]

  depends_on = ["google_project_service.container-service-nsoc", "google_project_service.container-service-retail"]
}
