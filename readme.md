```bash
1. variables
$ORG_ID = "1057308932815"
$BILLING_ACCOUNT = "01AD94-11DE90-A74FC7"

$DEV_PROJECT_ID = "gcp-dbt-dev"
$PROD_PROJECT_ID = "gcp-dbt-prod"

$REGION = "europe-west1"

$PROJECTS = @($DEV_PROJECT_ID, $PROD_PROJECT_ID)

2. Création des projets 
gcloud projects create $DEV_PROJECT_ID `
  --name="gcp-dbt-dev" `
  --organization=$ORG_ID

gcloud projects create $PROD_PROJECT_ID `
  --name="gcp-dbt-prod" `
  --organization=$ORG_ID

3. attachement du billing account 

foreach ($PROJECT in $PROJECTS) {
    gcloud billing projects link $PROJECT `
      --billing-account=$BILLING_ACCOUNT
}

4. Apis 

$APIS = @(
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "workflows.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "bigquery.googleapis.com",
    "storage.googleapis.com"
)

foreach ($PROJECT in $PROJECTS) {
    foreach ($API in $APIS) {
        gcloud services enable $API --project=$PROJECT
    }
}

5. buckets terraform 

foreach ($PROJECT in $PROJECTS) {
    gsutil mb -p $PROJECT -l $REGION "gs://tf-state-$PROJECT"
}

6. Services accounts 
foreach ($PROJECT in $PROJECTS) {
    gcloud iam service-accounts create terraform-sa `
      --project=$PROJECT
}

7. Iam roles 

$ROLES = @(
    "roles/bigquery.admin",
    "roles/storage.admin",
    "roles/workflows.admin",
    "roles/run.admin"
)

foreach ($PROJECT in $PROJECTS) {
    foreach ($ROLE in $ROLES) {
        gcloud projects add-iam-policy-binding $PROJECT `
            --member="serviceAccount:terraform-sa@$PROJECT.iam.gserviceaccount.com" `
            --role=$ROLE
    }
}


8. Workload identity 

$PROJECT_NUMBER = gcloud projects describe $DEV_PROJECT_ID `
  --format="value(projectNumber)"

  créer pool 

$POOL_ID = "github-pool"
$PROVIDER_ID = "github-provider"

gcloud iam workload-identity-pools providers create-oidc $PROVIDER_ID `
  --project=$DEV_PROJECT_ID `
  --location=global `
  --workload-identity-pool=$POOL_ID `
  --display-name="GitHub Provider" `
  --issuer-uri="https://token.actions.githubusercontent.com" `
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" `
  --attribute-condition="assertion.repository=='amaraboudib-sogeti/gcp-dbt-infra-tutorial'"

à faire si erreur : 
$REPO="amaraboudib-sogeti/gcp-dbt-infra-tutorial"

gcloud iam workload-identity-pools providers update-oidc github-provider `
  --project=$DEV_PROJECT_ID `
  --location=global `
  --workload-identity-pool=github-pool `
  --attribute-condition="assertion.repository=='$REPO'"


 autoriser github

$PROJECT_NUMBER = gcloud projects describe $DEV_PROJECT_ID `
  --format="value(projectNumber)"

gcloud iam service-accounts add-iam-policy-binding `
  terraform-sa@$DEV_PROJECT_ID.iam.gserviceaccount.com `
  --role="roles/iam.workloadIdentityUser" `
  --member="principalSet://iam.googleapis.com/projects/$PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/attribute.repository/$REPO"  




gcloud iam service-accounts add-iam-policy-binding `
  terraform-sa@gcp-dbt-prod.iam.gserviceaccount.com `
  --project=gcp-dbt-prod `
  --role="roles/iam.workloadIdentityUser" `
  --member="principalSet://iam.googleapis.com/projects/885925923288/locations/global/workloadIdentityPools/github-pool/attribute.repository/amaraboudib-sogeti/gcp-dbt-infra-tutorial"

gcloud iam service-accounts add-iam-policy-binding `
  terraform-sa@gcp-dbt-prod.iam.gserviceaccount.com `
  --project=gcp-dbt-prod `
  --role="roles/iam.serviceAccountTokenCreator" `
  --member="principalSet://iam.googleapis.com/projects/885925923288/locations/global/workloadIdentityPools/github-pool/attribute.repository/amaraboudib-sogeti/gcp-dbt-infra-tutorial"


$PROJECT_ID = "gcp-dbt-prod"
$PROJECT_NUMBER = "885925923288"
$REPO = "amaraboudib-sogeti/gcp-dbt-infra-tutorial"
$POOL = "github-pool"