## STEPS ##

###################################
# prerequisites # 
###################################
# aks cluster
# 
# Already have a docker file to use
# Create GitHub repo 

###################################
# Step 1 Create AKS # 
###################################
#### create a resource group variables #### 
AKS_RESOURCE_GROUP="Lab01-AKS" 
AKS_REGION="westus" 
AKS_SUBSCRIPTION="c88c8f23-28fa-446c-9737-a0a749bb194f" 
echo $AKS_RESOURCE_GROUP, $AKS_REGION 

#### Create Resource Group #### 
az group create -l ${AKS_REGION} -n ${AKS_RESOURCE_GROUP}  

#### create acr ####
ACR_NAME=acrsadey2klab01
echo $ACR_NAME

az acr create -n ${ACR_NAME} -g ${AKS_RESOURCE_GROUP} --sku Basic

#### aks variables #### 
CLUSTER_NAME=aks-lab01 
echo $CLUSTER_NAME 

#### create aks #### 
az aks create \
    -g ${AKS_RESOURCE_GROUP} \
    -n ${CLUSTER_NAME} \ 
    --node-count 2 \
    --enable-managed-identity \
    --generate-ssh-keys \
    --attach-acr ${ACR_NAME}


az aks create -g ${AKS_RESOURCE_GROUP}  -n ${CLUSTER_NAME} --node-count 2 --enable-managed-identity --generate-ssh-keys --attach-acr ${ACR_NAME}

### add monitoring is required ###
    --enable-addons monitoring \
    --enable-msi-auth-for-monitoring  \


### log into ACR ###
az acr login -n $ACR_NAME 

### build docker image ###  
docker build -t kube-nginx-acr:v2 . 

docker run -p 8080:8080 -tid kube-nginx-acr:v1 

### tag a docker image ### 
docker tag kube-nginx-acr:v2 acradedemo.azurecr.io/myapp/kube-nginx-acr:v1 

### list docker images to verify ###
docker images kube-nginx-acr:v1 

### push docker image to ACR ###
docker push acradedemo.azurecr.io/myapp/kube-nginx-acr:v1 

### List container images ###
az acr repository list --name acradedemo --output table 

### deploy maninfest to aks ###
kubectl apply -f deployment.yaml 

### Access Application  ###
http://<External-IP-from-get-service-output> 

### delete deployment ###
kubectl delete -f deployment.yaml 

#######################################################
### push images to github ###
#######################################################
mkdir name
cd to dir 
git remote add orgin https://github.com/sadey2k/20-acr-devops-build-pipeline 
git add .  
git commit -m "message" 
git push origin main  

## any issues run ##
git push -u origin --all

