#!/bin/bash 
# To launch and configure a server, run:
#     ./update ip-address nodes/default.json

address=$1
bundle exec knife solo cook sid137@$address  nodes/default.json
