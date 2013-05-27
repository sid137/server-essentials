#!/bin/bash

# To launch and configure a server, run:
#     ./deploy server-name

server_name=$1
rm -rf ~/.berkshelf/cookbooks
berks install

bundle exec knife digital_ocean droplet create \
  --image 25489              \
  --size 66                  \
  --location 1               \
  --ssh-keys 7798            \
  --bootstrap                \
  --solo                     \
  --server-name $server_name \
  --run-list "recipe[user], recipe[server-essentials]"
