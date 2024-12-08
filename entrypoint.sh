#!/bin/bash

set -e


export RAILS_ENV=${RAILS_ENV:-production}
echo $RAILS_ENV 
#echo "Seeding the database..."
rails db:seed

exec "$@"
