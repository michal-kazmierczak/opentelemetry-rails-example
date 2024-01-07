#!/bin/sh

./bin/rake db:migrate

if [ $? != 0 ]; then
  ./bin/rake db:setup
fi

exec "$@"
