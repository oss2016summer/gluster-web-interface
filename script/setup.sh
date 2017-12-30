#! /bin/bash

# Install bower, bundler, packages
function install {
  npm install bower
  bower install --allow-root
  gem install bundler
  bundle install
}

# setup
function setup {
  bin/rake db:migrate
}

# Go
case "$(uname -s)" in
  Darwin)
    echo 'Mac OS X'
    #brew install sshpass
    rbenv -v
    if [ $? -ne 0 ]; then
        echo 'Install rbenv'
        brew install rbenv
        brew install ruby-build
        echo 'export RBENV_ROOT=/usr/local/var/rbenv' >> ~/.bash_profile
        echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
        source ~/.bashrc
    fi
    rbenv install 2.3.3
    rbenv local 2.3.3
    install
    setup
    ;;

  Linux)
    echo 'Linux'
    # version check
    #if grep centos /etc/*-release; then
    #  echo "os : centos, use yum"
    #  yum install sshpass
    #elif grep ubuntu /etc/*-release; then
    #  echo "os : ubuntu, use apt-get install"
    #  apt-get install sshpass
    #fi
    echo 'Install essential packages'
    sudo apt-get update
    sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties
    rbenv -v
    if [ $? -ne 0 ]; then
        echo 'Install rbenv'
        git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
        source ~/.bashrc
    fi
    ruby-build --version
    if [ $? -ne 0 ]; then
        git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
        echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
        source ~/.bashrc
    fi
    rbenv install 2.3.3
    rbenv local 2.3.3
    install
    setup
    ;;

  CYGWIN*|MINGW32*|MSYS*)
    echo 'MS Windows'
    ;;

   *)
    echo 'other OS'
    ;;
esac
