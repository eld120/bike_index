FROM ruby:2.7.6-alpine

RUN apk update && apk add git make g++ gcc libc-dev
    




WORKDIR /app




# install ImageMagick
# RUN git clone https://github.com/ImageMagick/ImageMagick.git ImageMagick-7.1.1 \
#     cd ImageMagick-7.1.1 \
#     ./configure \
#     make


COPY . .
# RUN bundle add sidekiq
# RUN bin/setup

RUN chmod +x ./bin/setup start
RUN bin/setup
