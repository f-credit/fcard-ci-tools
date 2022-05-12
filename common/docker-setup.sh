#!/usr/bin/env bash

curl "https://download.docker.com/linux/static/stable/x86_64/docker-20.10.6.tgz" -o "docker.tgz"
tar xzvf docker.tgz
rm -rf docker.tgz
sudo cp docker/* /usr/bin/
rm -rf docker
sudo dockerd &
