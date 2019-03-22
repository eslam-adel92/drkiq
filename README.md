fisrt commit

docker-compose start drkiq && docker-compose exec drkiq bash -c 'rake db:migrate'

kubectl exec $(kubectl get pods -l app=drkiq | awk 'NR==2 {print $1}') -- bash -c 'rake db:migrate'

