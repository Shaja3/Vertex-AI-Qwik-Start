PROJECT_ID=`gcloud projects list  --format='value(project_id)'| grep qwiklabs-gcp | head -1`
gcloud config set project $PROJECT_ID
_______________________________________________________________________________________________________________________
curl -o default.sh https://raw.githubusercontent.com/aaturki/Clouders/edit/main/files/1/default.sh
source default.sh
_______________________________________________________________________________________________________________________
echo "${BOLD}${CYAN}$PROJECT_ID${RESET}"
_______________________________________________________________________________________________________________________
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  notebooks.googleapis.com \
  aiplatform.googleapis.com \
  bigquery.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  container.googleapis.com
  _______________________________________________________________________________________________________________________
SERVICE_ACCOUNT_ID=vertex-custom-training-sa
gcloud iam service-accounts create $SERVICE_ACCOUNT_ID  \
    --description="A custom service account for Vertex custom training with Tensorboard" \
    --display-name="Vertex AI Custom Training"
PROJECT_ID=$(gcloud config get-value core/project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/storage.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/bigquery.admin"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/aiplatform.user"
_______________________________________________________________________________________________________________________
gcloud services enable notebooks.googleapis.com
#gcloud compute images describe-from-family tf2-ent-2-3-cpu --project deeplearning-platform-release
_______________________________________________________________________________________________________________________
gcloud notebooks instances create instance-without-gpu \
  --vm-image-project=deeplearning-platform-release \
  --vm-image-family=tf2-ent-2-3-cpu \
  --machine-type=n1-standard-4 \
  --location=us-central1-a
  _______________________________________________________________________________________________________________________
gcloud notebooks instances list --location=us-central1-a
_______________________________________________________________________________________________________________________
warning "https://console.cloud.google.com/vertex-ai/workbench/list/instances?project=$PROJECT_ID"
STATE=$(gcloud notebooks instances list --location=us-central1-a --format='value(STATE)')
echo $STATE
while [ $STATE = PROVISIONING ]; 
do echo "PROVISIONING" && sleep 2 && STATE=$(gcloud notebooks instances list --location=us-central1-a --format='value(STATE)') ; 
done
_______________________________________________________________________________________________________________________
if [ $STATE = 'ACTIVE' ]
then
echo "${BOLD}${GREEN}$STATE ${RESET}"
fi
_______________________________________________________________________________________________________________________
JUPYTERLAB_URL=`gcloud notebooks instances describe instance-without-gpu --location=us-central1-a --format='value(proxyUri)'`
warning "Visit ${CYAN}https://$JUPYTERLAB_URL ${YELLOW}to open Jupyterlab"
_______________________________________________________________________________________________________________________
warning "Run below command in Jupyterlab Terminal:
${MAGENTA}
	git clone https://github.com/GoogleCloudPlatform/training-data-analyst"
_______________________________________________________________________________________________________________________
completed "Task 1"
_______________________________________________________________________________________________________________________
completed "Lab"
_______________________________________________________________________________________________________________________
remove_files
