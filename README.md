# Gluster Web Interface

A web interface for easier use and management of [Glusterfs](https://gluster.org).  
Tested on Linux, OS X (in progress).

## Requirement

* gluster server
* ruby (version: 2.3.3)
* sudo privileges **"without password"** [(see here)](http://askubuntu.com/questions/147241/execute-sudo-without-password)

## Install

``` bash
git clone https://github.com/oss2016summer/gluster-web-interface.git [directory name]
cd [directory name]
script/setup.sh
```

## Usage

``` bash
rails s -b 0.0.0.0
```

If you want access via public network, use additional module like [localtunnel](https://github.com/localtunnel/localtunnel)

## Contribution

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), everyone is encouraged to help improve this project. Here are a few ways you can pitch in:

 - Report bugs or issues
 - Fix bugs and submit pull requests.
 - Write, clarify or fix documentation.
 - Refactor code.
