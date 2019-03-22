#!/bin/bash
kubectl create -f drkiq-postgres/
kubectl create -f drkiq-redis/
kubectl create -f drkiq-app/
kubectl create -f drkiq-sidekiq/
