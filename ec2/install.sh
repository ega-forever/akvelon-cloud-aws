#!/bin/bash

curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs npm git
git clone https://github.com/ega-forever/akvelon-cloud-aws.git akvelon && \
  cd akvelon/ec2/app && npm install && \
  npm install -g pm2 && pm2 start index.js && \
  pm2 startup systemd && pm2 save
