all: api

api: build deploy

build: 
	bazelisk run :api_container -- push

deploy:
	gcloud run deploy api --project=chowwow --image=gcr.io/chowwow/api --region=us-east1 --platform managed

.PHONY: api build deploy
