# Dockrizing Ruby on Rails application.

This repository for dockrizing a ruby on rails application, by running it through a docker compose file, then convert it to kubernetes cluster and testing it.

## Refrences:
* Following tutorial from this [link](https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application), then do some edits on it to make it run through docker, then convert it to a kubernetes cluster.

## First the 3 parts:
- The drkiq_app directory, this directory contains the ruby on rails application which we built from the refrence link.
- The docker-compose and Dockerfile,

   Dockerfile: which are creating the drkiq_app image
   
   docker-compose.yml: which gather all the services we need to run the application which are the app, sidekiq service, postgresql database and redis database for caching.

- The k8s-drkiq directory which contains the kubernetes files which contains the file that convert the application to a kubernetes cluster.

## Runing the app
After cloning the repo:

- To create the docker image & create the containers need to run this command inside the path of the cloned repo:

```bash
docker-compose up -d
```
This command will build the image then run the containers needed with all the configrations.

Now the containers are running but the drkiq application container will stop as there is no database created yet, to create the database run the below command:

```bash
docker-compose start drkiq && docker-compose exec drkiq bash -c 'rake db:migrate'
```
- Now you can test the app through you browser open the belo link:
```
http://localhost:8000
```

# Next let's convert the application to a kubernetes cluster:
- This directory is contains to 4 directory each one has the related files which make all the deployments, services and configmaps used in the cluster.
- In the drkiq_app and drkiq_sidekiq you will find that I've used an image called "eslam2017/drkiq_app:k8s" I've built this image and pushed it to my account to be easy to use but you are free to build and image by your self then use it it will make no diffrence.
- To run the kubernetes cluser, inside the k8s-drkiq directory there is a shell script with the name "deploy_script.sh"
run it as below:
```bash
./deploy_script.sh
```
- Then after you make sure that the cluser is created and all the pods are running, run the below command to create the database to make the app work:
```bash
kubectl exec $(kubectl get pods -l app=drkiq | awk 'NR==2 {print $1}') -- bash -c 'rake db:migrate'
```
- After the database is created if you running the cluster on minikube, run the below command to test the app if it is working or not:

```bash
minikube service drkiq
```
or you can run:
```bash
kubectl get svc drkiq
```
Then open in the browser the minikube IP with the port from the prevous command.
