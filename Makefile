docker-build:
	docker build -t status-api .

docker-run: docker-build
	docker run -p 4000:4000 status-api

curl:
	curl http://localhost:4000/$(route) -i
