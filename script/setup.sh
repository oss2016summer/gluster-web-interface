#! /bin/sh

# setup
sudo npm install -g bower
sudo --askpass bower install --allow-root
gem install bundler
bundle install
bin/rake db:migrate

# make configuration file

CONF_PATH=`pwd`/configure.conf

if ls `pwd` | grep configure.conf; then
echo "configure.conf exist"
else
touch $CONF_PATH
echo "project_path=`pwd`" >> $CONF_PATH
echo "server_name=gluster" >> $CONF_PATH
echo "host_ip=127.0.0.1" >> $CONF_PATH
echo "host_port=" >> $CONF_PATH
echo "host_user=root" >> $CONF_PATH
echo "host_password=secret" >> $CONF_PATH
fi
