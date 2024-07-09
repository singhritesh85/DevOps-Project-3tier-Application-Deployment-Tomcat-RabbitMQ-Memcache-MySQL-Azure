# DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure
Architecture Diagram for three tier Application Deployment
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/f71c56a4-075b-49aa-a08c-9297a41ce472)
Using the Terraform Script present in this repository create the end-to-end Infrastructure.
<br><br/>
For RabbitMQ Installation and cluster creation followed below procedure.

**Node-1 (rabbitmq-vm-1)**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/988cf50d-cf6f-4322-8d16-bce8f02ab3d7)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/84cfa12b-a310-4bfc-a67f-a07d949edbe6)
create user and provide permission to the user.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/e1dcd844-4f55-4901-96df-ac5040d107f4)
**Node-2 (rabbitmq-vm-2)**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/baf808be-7979-4871-9747-c530f05843a8)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/c4680fd2-e549-4c34-92ef-ab933937ebcd)
**Node-3 (rabbitmq-vm-3)**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/97c80162-0a0c-48c1-891c-c44567f13216)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/b3a5ebd3-63a5-4710-9815-091fe0fbfabf)
**Creation of RabbitMQ Cluster**

**Node-1**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/9ed2368a-042e-4a14-8ee3-d5c2b05f4527)
**Node-2**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/3520a813-256d-4d52-a6bf-7f9b393b992a)
**Node-3**
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/b23c66da-2760-43a7-8c28-6a72b45d0cf3)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/1abb9daf-d63d-4020-a5da-dcf60ae28c76)
```
Run below command on Node-1 to set the policy for High Availability (HA) in RabbitMQ Cluster.
rabbitmqctl set_policy ha-all ".*" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
```
Finally copy the Public IP of the Application Gateway of RabbitMQ and create the Record Set in Azure DNS Zone. Access the URL and you will see the default console for RabbitMQ, you can use the initial username and password as guest and login into the RabbitMQ console. 
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/4a58ec72-915f-4a7e-9563-8d1a78059f53)
<br><br/>
The source code is present in Azure Repos. I have taken the Source Code present in GitHub Repository https://github.com/singhritesh85/Three-tier-WebApplication.git and did changes in pom.xml and application.properties as shown below.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/4454fc74-8fcd-49af-a248-d267ab175db2)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/c4b40def-a958-44b3-b966-5cda9e0f084d)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/4e9d66a4-bc94-430c-92b4-cdde0684e8b5)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/b84470f1-561d-4e75-a306-c265cb17e7cb)
Provide Contibutor Access for Azure Artifacts as shown in screenshot below.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/1aa3cd00-677e-472b-97e7-6e0fb4c43f13)
Create a database named as account in mysql and import the file db_backup.sql.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/17ef341d-a9a2-4060-a688-30139c057d7b)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/8248e084-f8fd-4318-9536-713f971d16b4)
I have created Service Connection for SonarQube and Azure Artifacsts as shown below.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/0f4bb3dc-2643-43de-a1d1-6c50f499190a)
<br><br/>
Passwordless Authentication is established between Azure DevOps agent and Tomcat Server (Backend Server).

Now Run the Azure Pipeline (the azure-pipelines.yaml is used as provided with this repository). Create the URL using Public IP for Nginx server after providing an entry for the same in DNS Zone. Access the newly created URL and provide username admin_vp and password admin_vp. 
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/557412fe-d2b4-42ea-a360-e48669f3787a)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/6212ee8d-5aff-4745-909f-5c58c5e494a1)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/58e762d9-d926-49c0-9c47-ef18f4ddd86c)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/587cc681-cfd9-4c83-960e-971af6f15f65)
When you click on the User for the first time it will get the values from MySQL Database and store it in Memcache, so that next time when you click on the same user it will provide the values from the Memcache itself.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/6dd652a4-5bd6-4e22-93d4-50b500abe37e)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/40841517-74bc-44a6-9598-f1ffc528ddee)
After running the Azure Pipeline the Screenshot for RabbitMQ, SonarQube, Azure Artifacts are as shown in the Screenshot below.
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/be460577-0c89-4ec2-94ab-af099d7c5d98)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/eca1290b-5fc0-4c8d-949b-2497d6bd3e3b)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/eb73b102-fde4-4ec4-8ee0-a3e3217ec9c1)
![image](https://github.com/singhritesh85/DevOps-Project-3tier-Application-Deployment-Tomcat-RabbitMQ-Memcache-MySQL-Azure/assets/56765895/8208ba7c-7e63-41d0-8a1b-a5fd3d20d70b)
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
```
Source Code:-  https://github.com/singhritesh85/Three-tier-WebApplication.git
```
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
<br><br/>
```
Reference:-  https://github.com/logicopslab/vprofile-project.git
```
