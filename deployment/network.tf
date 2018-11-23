# Create the hosted network.
resource "google_compute_network" "corporate_network" {
  name                    = "corporate-network"
  auto_create_subnetworks = "false"
  project                 = "${google_project.nsoc-host-demo-project.project_id}"
}

resource "google_compute_subnetwork" "mgmt-eu-subnetwork" {
  name                     = "mgmt-eu-subnetwork"
  ip_cidr_range            = "${var.mgmt_eu_ip_cidr_range}"
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = "${google_compute_network.corporate_network.self_link}"
  project                  = "${google_project.nsoc-host-demo-project.project_id}"
}

resource "google_compute_subnetwork" "retail-eu-subnetwork" {
  name                     = "retail-eu-subnetwork"
  ip_cidr_range            = "${var.retail_eu_ip_cidr_range}"
  region                   = "europe-west1"
  private_ip_google_access = true

  network = "${google_compute_network.corporate_network.self_link}"
  project = "${google_project.nsoc-host-demo-project.project_id}"
}
