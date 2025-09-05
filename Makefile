docker-build:
	docker build -t status-api .

#4000:4000 é redirecionando a porta do dispositivo para a porta do docker
docker-run: docker-build
	docker run -p 4000:4000 status-api

curl:
	curl http://localhost:4000/$(route) -i
