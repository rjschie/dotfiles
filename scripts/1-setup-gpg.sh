#!/bin/bash

# Setup GPG
gpg --full-generate-key
echo "\n\n"
gpg --list-secret-keys --keyid-format=long
