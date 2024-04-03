#!/bin/bash

# Setup SSH
ssh-keygen -t ed25519 -C "rjschie@gmail.com" -f ~/.ssh/id_main -N ""
ssh-agent -s
ssh-add ~/.ssh/id_main

cp "$PWD/templates/ssh-config" ~/.ssh/config
