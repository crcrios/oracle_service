FROM bitwalker/alpine-elixir:1.13.4 as build
#FROM artifactory.apps.bancolombia.com/evc/stable/elixir:1.13.4-alpine.v1
run elixir --version
ENV APP_NAME="oracle_service"
RUN apk add build-base
RUN apk update && apk upgrade && apk add gcc musl-dev rust cargo
WORKDIR /app
COPY . /app
RUN mix local.hex --force 
RUN mix local.rebar --force 
RUN mix deps.get 
RUN mix deps.compile 
RUN mix distillery.init
RUN MIX_ENV=prod mix distillery.release 
RUN rm -rf /app/_build/prod/rel/$APP_NAME/etc

FROM bitwalker/alpine-elixir:1.13.4
#FROM artifactory.apps.bancolombia.com/evc/stable/elixir:1.13.4-alpine.v1
ENV APP_NAME="oracle_service"
WORKDIR /app
EXPOSE 8003
RUN apk update && apk upgrade && apk add bash && mkdir -p /app/rel/$APP_NAME/var
COPY --from=0 /app/_build/prod /app
VOLUME /app/rel/$APP_NAME/etc
#USER #{elixir_user}#
ENTRYPOINT exec /app/rel/$APP_NAME/bin/$APP_NAME foreground
