#! /bin/sh

#version check
if grep centos /etc/*-release; then
echo "os : centos, use yum"
elif grep ubuntu /etc/*-release; then
echo "os : ubuntu, use apt-get install"
fi

# setup
sudo npm install -g bower
sudo --askpass bower install --allow-root
gem install bundler
bundle install
bin/rake db:migrate
