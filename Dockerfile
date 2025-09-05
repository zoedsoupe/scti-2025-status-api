FROM elixir:1.18-otp-28

ARG PORT=4000

# Configura ambiente para produção
ENV MIX_ENV=prod PORT=$PORT

WORKDIR /app

# Instala repositórios de dependêsncias
RUN mix local.hex --force && \
    mix local.rebar --force

# Copia arquivo de entrada do projeto
COPY mix.exs mix.lock ./

# Instala depêndencias
RUN mix deps.get
RUN mix deps.compile

# Compila o projeto (vai ser interpretado)
RUN mix compile

# Copia código fonte
COPY .formatter.exs .
COPY lib ./lib

EXPOSE $PORT

CMD ["mix", "run", "--no-halt"]
