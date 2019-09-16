# Build Base image
FROM ruby:2.6.4 as base

# Environment variables
ENV DOCKERIZE_VERSION v0.6.1
ENV APP_PATH /var/www/code_fund_ads

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  graphviz \
  imagemagick \
  libpq-dev \
  netcat \
  postgresql-client \
  postgresql-contrib \
  wget \
  nodejs

# Add Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Add Dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Create directory for the app
RUN mkdir -p $APP_PATH

# Build intermediate
FROM base as intermediate

# Set working directory
WORKDIR $APP_PATH

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update rubygems version
RUN gem update --system

# Install bundler 2.0.2,
RUN gem install bundler:2.0.2

# Build Development image
FROM base as development

COPY --from=intermediate $APP_PATH $APP_PATH

WORKDIR $APP_PATH
