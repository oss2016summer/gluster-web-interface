# Gluster Web Interface

[Gluster](https://gluster.org) client web interface for managing and using glusterfs more efficiently.

## Requirement

* glusterfs cluster
* ruby (version: 2.3.0)
* sudo privileges **"without password"** [(see here)](http://askubuntu.com/questions/147241/execute-sudo-without-password)


## Setup

```
git clone https://github.com/oss2016summer/gluster-web-interface.git
cd gluster-web-interface
script/setup.sh
rails s
```
That's it! Navigate to http://localhost:3000  

If you want access via public network, use additional module like [localtunnel](https://github.com/localtunnel/localtunnel)

## Contributing

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), everyone is encouraged to help improve this project. Here are a few ways you can pitch in:

 - Report bugs or issues
 - Fix bugs and submit pull requests.
 - Write, clarify or fix documentation.
 - Refactor code.
