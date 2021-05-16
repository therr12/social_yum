all: web

web: build deploy

build: 
	flutter build web

deploy:
	firebase deploy

.PHONY: web build deploy
