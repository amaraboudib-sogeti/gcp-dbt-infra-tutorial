resource "google_workflows_workflow" "pipeline" {
  name            = "data-pipeline"
  region          = var.region
  project         = var.project_id
  service_account = var.service_account

  source_contents = file("${path.module}/workflow.yaml")
}