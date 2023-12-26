#!/bin/bash

git clone "$BLUEBERRY_SRC_URL" 2> /dev/null || (cd blueberry; git pull)
cd blueberry
mix deps.get
mix ecto.create
mix ecto.migrate
mix release
PHX_SERVER=1 ./_build/prod/rel/blueberry/bin/blueberry start
