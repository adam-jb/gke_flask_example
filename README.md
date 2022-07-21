# gke_flask_example


To run flask app on GKE with a load balancer
Based on https://cloud.google.com/kubernetes-engine/docs/quickstarts/deploy-app-container-image


Deploying to GKE needs 2 things:
1. 'Deployment': main server nodes
2. 'Service': entry point, inc load balancer. Gives a single stable IP address and distributes traffic to deployment nodes

A service will have an external IP you can access from the internet

Can view CPU usage in 'Workloads' tab of GKE dashboard






### To deploy in Cloud Shell, where 'volatility-portfolio-bot' is my project ID
```
git clone https://github.com/adam-jb/gke_flask_example.git
cd gke_flask_example

# get ID of current GCP project
PROJECT_ID=$(gcloud config get-value project) 

# set default location to store repo
gcloud config set artifacts/location europe-west2


# making artifact repo
gcloud artifacts repositories create gke-flask-example \
    --repository-format=docker \
    --project=volatility-portfolio-bot \
    --description="docker repository"


# building image
 gcloud builds submit \
    --tag europe-west2-docker.pkg.dev/volatility-portfolio-bot/gke-flask-example/gke_flask_example .


# make GKE cluster using manual number of modes, instead of 'autopilot' which autoscales
gcloud container clusters create gke-flask-example \
    --num-nodes 2 \
    --zone europe-west2-b


# deploy resource to cluster
kubectl apply -f deployment.yaml

# monitor how deployment is going
kubectl get deployments

# another way to see how its going is looking at the status of pods:
kubectl get pods


# to update a given deployment just reapply the yaml file
kubectl apply -f deployment.yaml


# deploy service resource
kubectl apply -f service.yaml


# view status of service and IP addresses it provides
kubectl get services


```


### To log usage of cluster in BigQuery dataset 'test_k8_logs'

```
# update existing cluster. Takes a few minutes
gcloud container clusters update gke-flask-example \
    --resource-usage-bigquery-dataset test_k8_logs \
    --region=europe-west2-b


# check GKE usage metering is enabled
gcloud container clusters describe gke-flask-example \
    --format="value(resourceUsageExportConfig)" \
    --region=europe-west2-b

```



### To delete cluster and image
```
gcloud container clusters delete gke-flask-example --region=europe-west2-b --quiet

gcloud artifacts docker images delete \
    europe-west2-docker.pkg.dev/volatility-portfolio-bot/gke-flask-example/gke_flask_example

```






