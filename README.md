
NOTE: I am attaching the output as well for the command I am running.

Attached ip.txt - for AWS ECS Fargate load balancer url

Attached ip2.txt - for AWS EC2 docker container url

1. Created the Dockerfile with Python as a base image, Dockerfile code is attached.

2. Created the image using following command

 docker build -t overbondimage .
Sending build context to Docker daemon  75.26kB
Step 1/6 : FROM python:3
 ---> da24d18bf4bf
Step 2/6 : WORKDIR /usr/src/app
 ---> Using cache
 ---> 4f4f124cbcb0
Step 3/6 : COPY app.py ./
 ---> Using cache
 ---> 9193c8fb3622
Step 4/6 : RUN pip install --no-cache-dir flask
 ---> Using cache
 ---> b4886829baf7
Step 5/6 : ENV MY_NAME=Prakash
 ---> Running in 82ae90256606
Removing intermediate container 82ae90256606
 ---> c301254de0eb
Step 6/6 : CMD [ "python", "./app.py" ]
 ---> Running in a1e527ed6af9
Removing intermediate container a1e527ed6af9
 ---> 4531248aa0fc
Successfully built 4531248aa0fc
Successfully tagged overbondimage:latest


3. Tested the image by running it locally once by using below command

docker run -d -t -i -p 80:80 overbondimage
485891967dacbdabd75d8f2033a8d336166b6739ae007e685873cfaa278f3150
[root@ip-172-31-13-43 sre-test]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                NAMES
485891967dac        overbondimage       "python ./app.py"   4 seconds ago       Up 3 seconds        0.0.0.0:80->80/tcp   awesome_ritchie


4. Its running well on http://18.219.228.104/

Getting the following output

Hello Overbond, my name is Prakash!

#######################################################################################################################

NEXT : RUNNING IT ON AWS 

######################################################################################################3

NOTE: Will be using ECS FARGATE to run this container


1. Created the AWS ECR reposiotry for storing the image

aws ecr create-repository --repository-name overbond-assignment --region us-east-2  (Creating new repository)
{
    "repository": {
        "repositoryUri": "015268366847.dkr.ecr.us-east-2.amazonaws.com/overbond-assignment",
        "imageScanningConfiguration": {
            "scanOnPush": false
        },
        "encryptionConfiguration": {
            "encryptionType": "AES256"
        },
        "registryId": "015268366847",
        "imageTagMutability": "MUTABLE",
        "repositoryArn": "arn:aws:ecr:us-east-2:015268366847:repository/overbond-assignment",
        "repositoryName": "overbond-assignment",
        "createdAt": 1611123842.0
    }
}


2. docker tag overbondimage 015268366847.dkr.ecr.us-east-2.amazonaws.com/overbond-assignment (Tagging the image)

3.  aws ecr get-login-password | docker login --username AWS --password-stdin 015268366847.dkr.ecr.us-east-2.amazonaws.com (Doing docker login)

4. docker push 015268366847.dkr.ecr.us-east-2.amazonaws.com/overbond-assignment (Pushing the image to ECR)

The push refers to repository [015268366847.dkr.ecr.us-east-2.amazonaws.com/overbond-assignment]
8b5cf0007932: Pushed
88a85730ada1: Pushed
ac668705fd05: Pushed
394ec6c8d61d: Pushed
c5e393b8a19a: Pushed
b3f4557ae183: Pushed
9f5b4cdea532: Pushed
cd702377e4e5: Pushed
aa7af8a465c6: Pushed
ef9a7b8862f4: Pushed
a1f2f42922b1: Pushed
4762552ad7d8: Pushed
latest: digest: sha256:cca2b268e878e2c80938b079e0dac88721bbf23a9e542f178ec394f76efea5ff size: 2842

5. From console created the ECS service 

Details of ECS service are as follows:

Cluster-- overbond


Task definition -- first-run-task-definition:1

Service -- overbondpython-service

Load balancer --  arn:aws:elasticloadbalancing:us-east-2:015268366847:loadbalancer/app/EC2Co-EcsEl-4EBA2FWWZHYS/bb9d6af3e5db5370

NOTE: Passed the environment variable MY_NAME as AWS on PrakashAWS (In order to clear the response is from Fargate)

ECS Fargate Load balancer url is: http://ec2co-ecsel-4eba2fwwzhys-722309193.us-east-2.elb.amazonaws.com/

It is giving response as: Hello Overbond, my name is PrakashAWS!

#############################################################################################################

Overall Solution
#########################

1. REsponse from docker from EC2 instanceIP:  http://18.219.228.104/
2. Response from ECS Fargate Load Balancer: http://ec2co-ecsel-4eba2fwwzhys-722309193.us-east-2.elb.amazonaws.com/




