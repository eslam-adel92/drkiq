#!/bin/bash
kubectl apply -f drkiq-postgres/
kubectl apply -f drkiq-redis/
kubectl apply -f drkiq-app/
kubectl apply -f drkiq-sidekiq/
