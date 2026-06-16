resource "google_workflows_workflow" "pipeline" {
  name            = "data-pipeline"
  region          = var.region
<<<<<<< HEAD
=======
  project         = var.project_id
>>>>>>> dev
  service_account = var.service_account

  source_contents = file("${path.module}/workflow.yaml")
}