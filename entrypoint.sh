#!/bin/bash

set -e

#source /usr/local/bundle/bin/rails
#source /usr/local/bundle/bin/bundle

#echo "Creating the database..."
#bin/rails db:create

#export RAILS_ENV=${RAILS_ENV:-production}
#echo $RAILS_ENV 
# Precompile assets
#echo "Precompiling assets..."
#bundle exec rake assets:precompile

#echo "Running migrations..."
#bin/rails db:migrate
#echo "Seeding the database..."
#bin/rails db:seed
# Execute the given command (Rails server by default)
export RUBYOPT='-W0'

exec "$@"
