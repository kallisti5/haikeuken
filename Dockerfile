FROM ruby:2.7
MAINTAINER alex@terarocket.io

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs nginx

ENV RAILS_ROOT /opt/app
ENV RAILS_ENV production

RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY . .
RUN bundle config set without 'development test'
RUN bundle install --jobs 20 --retry 5 
RUN SECRET_KEY_BASE=1 bundle exec rake assets:precompile

EXPOSE 3000

ENTRYPOINT ["/opt/app/entry"]

HEALTHCHECK --interval=1m --timeout=25s --start-period=2m \
  CMD curl -f http://localhost:3000/ || exit 1
