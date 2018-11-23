/**
 * # 01-GKE-multi-demo-projects
 * This use case shows how the network team can share subnets to let customers deployed their own gke clusters
 * 
 * ![architecture schema](images/use-case-container.png)
 *
 * ## Components 
 * 3 projects : 
 * - nsoc (host project)
 * - retail (service project)
 * 
 * ## Contribute
 * main.tf : project skeleton   
 *
 * iam.tf : set permission to use and deploy ressources   
 *
 * network.tf : define virtual network architecture   
 *
 */

resource "random_string" "project_id" {
  length  = 4
  special = false
}

resource "google_project" "nsoc-host-demo-project" {
  name       = "nsoc-demo-project"
  project_id = "nsoc-demo-project-${lower(random_string.project_id.result)}"
  folder_id  = "${var.parent_folder}"

  billing_account     = "${var.billing_account}"
  auto_create_network = false

  labels {
    terraform = "true"
    owner     = "jerome-nahelou"
  }
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = "${google_project.nsoc-host-demo-project.project_id}"
}

resource "google_project" "retail-service-demo-project" {
  name       = "retail-demo-project"
  project_id = "retail-demo-project-${lower(random_string.project_id.result)}"
  folder_id  = "${var.parent_folder}"

  billing_account     = "${var.billing_account}"
  auto_create_network = false

  labels {
    terraform = "true"
    owner     = "jerome-nahelou"
  }
}

resource "google_compute_shared_vpc_service_project" "retail" {
  host_project    = "${google_compute_shared_vpc_host_project.host.project}"
  service_project = "${google_project.retail-service-demo-project.project_id}"

  depends_on = ["google_compute_shared_vpc_host_project.host", "google_project.retail-service-demo-project"]
}
