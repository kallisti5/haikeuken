FROM ruby:2.7
MAINTAINER alex@terarocket.io

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV RAILS_ROOT /opt/app
ENV RAILS_ENV production
RUN mkdir -p $RAILS_ROOT

WORKDIR $RAILS_ROOT

COPY . .
RUN bundle config set without 'development test'
RUN bundle install --jobs 20 --retry 5 
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
