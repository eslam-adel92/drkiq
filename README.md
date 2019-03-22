This repository for dockrize ruby on rails app in docker compose file, then convert it to kubernetes cluster and testing it.
Please follow the steps belo.

- First the 3 parts:
1- the drkiq_app directory, this directory contains the ruby on rails application.
2- The docker-compose and Dockerfile,
   Dockerfile: which are creating the drkiq_app image
   docker-compose.yml: 

docker-compose start drkiq && docker-compose exec drkiq bash -c 'rake db:migrate'

kubectl exec $(kubectl get pods -l app=drkiq | awk 'NR==2 {print $1}') -- bash -c 'rake db:migrate'

