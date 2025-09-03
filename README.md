# Service - Health Check API

API simples e mockada para health check e status do serviço.

## Endpoints

```
GET /         -> Status do serviço (418 - I'm a teapot)
GET /health   -> Health check com timestamp
GET /info     -> Versão e hostname do serviço
```

## Como rodar

### Mix

```bash
# Instalar dependências
mix deps.get

# Rodar aplicação
mix run --no-halt

# Em outro terminal, testar
curl -i localhost:4000/
curl -i localhost:4000/health
curl -i localhost:4000/info
```

### Docker

```sh
# EM um terminal
make docker-run

# Em outro
make curl route="/"
make curl route="/info"
make curl route="/health"
```

## Testes

```bash
mix test
```

## Para o workshop

Este projeto é usado no minicurso de DevOps/CI para demonstrar:
- Testes automatizados com ExUnit
- Plug/HTTP testing
- Pipeline CI/CD

