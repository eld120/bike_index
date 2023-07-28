FROM node:16.20-bullseye


ARG APP_HOME=/app
WORKDIR /app
COPY ./compose/test/entrypoint /entrypoint

COPY . ${APP_HOME}
ENTRYPOINT [ "/entrypoint" ]