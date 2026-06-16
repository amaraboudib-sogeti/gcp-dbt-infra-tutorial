resource "google_workflows_workflow" "pipeline" {
  name            = "data-pipeline"
  region          = var.region
  service_account = var.service_account

  source_contents = file("${path.module}/workflow.yaml")
}