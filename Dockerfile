# Base Image for All Stages
FROM ghcr.io/forem/ruby:3.3.0@sha256:9cda49a45931e9253d58f7d561221e43bd0d47676b8e75f55862ce1e9997ab5c AS base

# Stage 1: Builder Stage
FROM base AS builder

# Install build-time dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        libcurl4-openssl-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        libpcre3-dev \
        libpq-dev \
        pkg-config \
        git \
        && apt clean && rm -rf /var/lib/apt/lists/*

#RUN apt-get update && apt-get install -y redis-server

#RUN apt-get update && apt-get install -y build-essential protobuf-compiler


# Set environment variables for Bundler and jemalloc
#ENV BUNDLER_VERSION= \
 #   LD_PRELOAD=libjemalloc.so.2 \
  #  APP_HOME=/opt/apps/forem


 
ENV LD_PRELOAD=libjemalloc.so.2 \
    APP_HOME=/opt/apps/forem



#2.4.17
# Install Bundler
#RUN gem install -N bundler:${BUNDLER_VERSION}
RUN gem install -N bundler
# Create application directory and set permissions
RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

# Copy application dependencies and install Ruby gems
#COPY Gemfile Gemfile.lock ./
COPY Gemfile Gemfile.lock ./
COPY  vendor/cache ./vendor/cache
COPY .ruby-version ./
ENV RAILS_ENV=production
RUN bundle install
RUN RAILS_ENV=production bundle install --without development test


#RUN bundle update js-routes net-http-persistent google-protobuf


COPY  . .
RUN bin/rails db:create
# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile 
RUN bin/rails db:migrate

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/bin/entrypoint.sh
# Ensure the script is executable
RUN chmod +x /usr/bin/entrypoint.sh



# Expose port for the Rails server
EXPOSE 8080

# Set the entrypoint to the script
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Set default command to run the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "8080"]


