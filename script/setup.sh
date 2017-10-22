#! /bin/sh

# Install bower, bundler, packages
function install {
  sudo npm install -g bower
  sudo --askpass bower install --allow-root
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
