## An Azure DevOps and Azure Kubernetes Service demo pipeline.

### Summary
This repo demonstrates a web app deployment to Azure Kubernetes Service. The project is broken down into four pipelines:

- An infrastructure build pipeline (using Terraform)
- An application code build pipeline
- An application code release pipeline
- An infrastructure destroy pipeline

The core application components are:

- A voting application
- An analytics api
- An Azure Database for MySQL

In addition it demonstrates the use of several other technologies and concepts:

- Azure DevOps yaml based pipelines and templates
- Git and git branching strategy; prd & dev (more environments / branches could be easily added)
- Azure Application Gateway fronting both apps and protected with a TLS certificate
- Hub and spoke network design with Azure Firewall for outbound traffic
- Docker application build with an Azure Container Registry repo
- Terraform provision of environments based on branch name
- Authorisation gate to control and review terraform code changes
- Application monitoring with Application Insights
- Helm application packaging
- Code scanning with SonarCloud & TFSec
- Kubernetes application deployment including the following features:
  - AGIC: Application gateway add-on
  - CSI Driver: Azure keyvault secret retrieval
  - Cert-Manager: TLS certificate provider
  - OMS: Azure monitor integration
  - Cluster and pod (HPA) autoscalers
  - Azure CNI networking
  - Azure AD integration and role based access control
- Emergency rollback using helm rollback

### Overview
![Overview](https://raw.githubusercontent.com/rhod3rz/demo1-AzureDevOps-AKS/prd/screenshots/overview.png "Overview")

### Infrastructure Diagram
![Infrastructure Diagram](https://raw.githubusercontent.com/rhod3rz/demo1-AzureDevOps-AKS/prd/screenshots/infrastructure.png "Infrastructure Diagram")

### K8s Diagram
![K8s Diagram](https://raw.githubusercontent.com/rhod3rz/demo1-AzureDevOps-AKS/prd/screenshots/k8s.png "K8s Diagram")

### Pre-Requisites
The pipeline relies on the following components:

- Azure DevOps Service Connection  
An ADO service connection to Azure called 'payg2106'.  

- Azure DevOps Service Connection - Azure Container Registry (aka Docker Registry)  
An ADO service connection to Docker / Azure Container Registry called 'acrdlnteudemoapps210713'.  

- SonarCloud Service Connection  
A SonarCloud service connection to SonarCloud called 'SonarCloud'.

&nbsp;
### 1. The 'Infrastructure' Pipeline Workflow

The infrastructure pipeline focusses on building the Azure components. As changes are infrequently made to the infrastructure the pipeline 'trigger' is a manual process.

---
#### 1.1 Setup the Azure DevOps (ADO) Project.
---
a. In ADO create a project, then pipelines > new pipeline > github/yaml > select the correct repo > then create pipelines for the following files and rename as below:  

| YAML File | Rename Pipeline To |
| ------ | ----------- |
| 1-infrastructure.yml | 1-infrastructure |
| 2-build.yml | 2-build |
| 3-release.yml | 3-release |
| 9-destroy.yml | 9-destroy |

---
#### 1.2 Build the 'prd' Branch.
---
a. Manually run the '1-infrastructure' pipeline. Review the plan at the 'Wait for Validation' stage, and if happy authorise to proceed.  

Pipeline Actions:
- Evaluates the branch name and Terraform provisions the 'prd' environment (inc. manual approval gate).

Output:
- You now have one environment deployed, 'prd'.

---
#### 1.2 Build the 'dev' Branch.
---
a. Create a new branch 'dev', and switch to it.  
`git checkout -b dev`  
b. Push the 'dev' branch to github.  
`git add .`  
`git commit -m "dev infrastructure deployment"`  
`git push -u origin dev`  
c. Manually run the '1-infrastructure' pipeline against the 'dev' branch. Review the plan at the 'Wait for Validation' stage, and if happy authorise to proceed.  

Pipeline Actions:
- Evaluates the branch name and Terraform provisions the 'dev' environment (inc. manual approval gate).

Output:
- You now have two environments deployed, 'prd' and 'dev'.

---
#### 1.3 Future Changes.
---
Future changes are implemented by making changes in 'dev' and creating a pull request to merge to 'prd'.

&nbsp;
### 2. The 'Build' Pipeline Workflow
The build pipeline focusses on building the code and creating a docker image ready for deployment. As changes are frequently made, the pipeline 'trigger' is automatic.

---
#### 2.1 Build the 'prd' Branch.
---
a. Update line 28 in src\voting\server.js with a new timestamp.  
b. Push the 'prd' branch to github.  
`git add .`  
`git commit -m "prd build deployment 230929-1022"`  
`git push -u origin prd`  
c. The pipeline '2-build' should automatically trigger.

Pipeline Actions:
- Creates two 'prd' docker images; one for analytics and one for voting and pushes them to ACR.

Output:
- You now have a docker image ready for testing or deployment.

---
#### 2.2 Build the other branches.
---
The steps above can be repeated to build 'dev'. They're covered in the release steps below.

&nbsp;
### 3. The 'Release' Pipeline Workflow

The release pipeline focusses on deploying docker images to Azure Kubernetes Service. For control, this is a manual step where you specify the image tag you want to deploy.

---
#### 3.1 Release the 'prd' Branch.
---
a. Manually run '3-release' against the 'prd' branch. Enter the 'Docker Tag' you want to deploy; this is a required field e.g. 20230929.3-prd.  

Pipeline Actions:
- Evaluates the branch name and deploys a helm chart to Azure Kubernetes Service ('prd' environment).

Output:
- You now have the 'prd' environment deployed.  
Test using the following urls https://prd.rhod3rz.com and https://prd.rhod3rz.com/analytics.

---
#### 3.2 Release the 'dev' Branch.
---
It's time to simulate a change ...  

a. Switch to the 'dev' branch.  
`git checkout dev`  
b. Update line 20 in src\voting\server.js with a new timestamp.  
c. Push the 'dev' branch to github.  
`git add .`  
`git commit -m "dev build deployment 230929-1552"`  
`git push -u origin dev`  
d. The pipeline '2-build' should automatically trigger; wait for this to finish.  
e. Manually run '3-release' against the 'dev' branch. Enter the 'Docker Tag' you want to deploy; this is a required field e.g. 20230929.13-dev.

Pipeline Actions:
- Creates two 'dev' docker images; one for analytics and one for voting and pushes them to ACR.
- Evaluates the branch name and deploys a helm chart to Azure Kubernetes Service ('dev' environment).

Output:
- You now have the 'dev' environment deployed.  
Test using the following url https://dev.rhod3rz.com and https://dev.rhod3rz.com/analytics.  
When running the app, notice the timestamp in the 'dev' environment is now the updated one you set in step 3.2b.

---
#### 3.3 Merge the 'dev' Branch to 'prd' Branch.
---
Assuming there were no issues with the 'dev' deployment it's time to merge those changes into 'prd' ...

a. Create a 'Pull Request' to merge 'dev' into 'prd'.  
b. The pipeline '2-build' should automatically trigger; wait for this to finish.  
c. Manually run '3-release' against the 'prd' branch. Enter the 'Docker Tag' you want to deploy; this is a required field e.g. 20230929.7-prd.

Pipeline Actions:
- Creates two 'prd' docker images; one for analytics and one for voting and pushes them to ACR.
- Evaluates the branch name and deploys a helm chart to Azure Kubernetes Service ('prd' environment).

Output:
- You've just updated 'prd'.  
Test as before e.g. https://prd.rhod3rz.com and https://prd.rhod3rz.com/analytics.  
When running the app, notice the version number in the 'prd' environment is now the updated one you pushed through 'dev'.

---
#### 3.5. Emergency Rollback.
---
Instructions:

Oh dear, 🤦‍♂️ something has been missed in testing! You need to rollback to the previous version asap ...

a. View the helm history to see the previous versions.  
`helm history titan -n titan`  
b. Rollback:  
`helm rollback titan -n titan 0`  

NOTE: 0 will roll back to the previous version; else use a specific version number.
