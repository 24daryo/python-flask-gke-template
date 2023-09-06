export PROJECT_ID=<YOUR_PROJECT>
export POOL_NAME=github-actions-pool
export POOL_DISPLAY_NAME=github-actions-pool
export PROVIDER_NAME=github-actions-provider
export PROVIDER_DISPLAY_NAME=github-actions-provider
export SERVICE_ACCOUNT_NAME=mec-kaunsell-gke
export SERVICE_ACCOUNT_DISPLAY_NAME=mec-kaunsell-gke
export GITHUB_REPO=<Organization>/<Repository>

gcloud iam workload-identity-pools create "${POOL_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="${POOL_DISPLAY_NAME}"

# 後で利用する変数をExport
export WORKLOAD_IDENTITY_POOL_ID=$( \
     gcloud iam workload-identity-pools describe "${POOL_NAME}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --format="value(name)" \
)

gcloud iam workload-identity-pools providers create-oidc "${PROVIDER_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_NAME}" \
  --display-name="${PROVIDER_DISPLAY_NAME}" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITHUB_REPO}"

gcloud iam workload-identity-pools providers describe "${PROVIDER_NAME}" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${POOL_NAME}" \
  --format='value(name)'

# 以下のような結果が返ってきていれば正しく設定されています。
# projects/<PROJECT_ID>/locations/global/workloadIdentityPools/<POOL_NAME>/providers/<PROVIDER_NAME>