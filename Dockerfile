###
# Enclose latest Haikeuken in a docker container
###

FROM fedora:latest

RUN yum update -y
RUN yum install -y nginx postgresql-client libpq-dev
RUN yum install -y curl
RUN yum install -y git
RUN yum install -y nodejs
RUN yum install -y python
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Install rvm, ruby, bundler
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# Add rails project to project directory
RUN mkdir -p /app/haikeuken

# set WORKDIR
WORKDIR /app/haikeuken

# Add our current code...
ADD ./ /app/haikeuken
ADD config/container/nginx-site.conf /etc/nginx/sites-enabled/default
ADD config/container/start-server.sh /usr/bin/start-server

# ... or clone latest upstream
#RUN git clone https://github.com/kallisti5/haikeuken.git .
#RUN cp /app/haikeuken/config/container/nginx-site.conf /etc/nginx/sites-enabled/default
#RUN cp /app/haikeuken/onfig/container/start-server.sh /usr/bin/start-server

# Make exec
RUN chmod +x /usr/bin/start-server

# bundle install
RUN /bin/bash -l -c "bundle install"

# Publish port 80
EXPOSE 80

# Startup commands
ENTRYPOINT /usr/bin/start-server
