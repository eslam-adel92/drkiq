# Use the barebones version of Ruby 2.2.3.
#FROM ruby:2.2.3-slim
FROM ruby:2.3.0-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Nick Janetakis <nick.janetakis@gmail.com>

# Install dependencies:
#   - build-essential: To ensure certain gems can be compiled
#   - nodejs: Compile assets
#   - libpq-dev: Communicate with postgres through the postgres gem
#   - postgresql-client-9.4: In case you want to talk directly to postgres
RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV INSTALL_PATH /drkiq
RUN mkdir -p $INSTALL_PATH

# This sets the context of where commands will be ran in and is documented
# on Docker's website extensively.
WORKDIR $INSTALL_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
COPY Gemfile Gemfile
RUN bundle install 

# Copy in the application code from your work station at the current directory
# over to the working directory.
COPY . .

# ENV variables from .drkiq.env
ENV SECRET_TOKEN 33bcbea703379cedd7055ab152741922b2765dc4d68540b935b9be8161fd379a143edebf8ed8121326fd2950e05c561d8a6be72347b2d9e99ece7327e0b7cc2c
ENV WORKER_PROCESSES 1
ENV LISTEN_ON 0.0.0.0:8000
ENV DATABASE_URL postgresql://drkiq:123456@postgres:5432/drkiq?encoding=utf8&pool=5&timeout=5000
ENV CACHE_URL redis://redis:6379/0
ENV JOB_WORKER_URL redis://redis:6379/0

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://drkiq:123456@postgres/drkiq SECRET_TOKEN=33bcbea703379cedd7055ab152741922b2765dc4d68540b935b9be8161fd379a143edebf8ed8121326fd2950e05c561d8a6be72347b2d9e99ece7327e0b7cc2c assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$INSTALL_PATH/public"]

# The default command that gets ran will be to start the Unicorn server.
CMD bundle exec unicorn -c config/unicorn.rb
