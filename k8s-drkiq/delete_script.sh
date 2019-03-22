#!/bin/bash
kubectl delete -f drkiq-postgres/
kubectl delete -f drkiq-redis/
kubectl delete -f drkiq-app/
kubectl delete -f drkiq-sidekiq/
