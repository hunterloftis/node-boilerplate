# node-boilerplate
      
Structure for your non-trivial [node.js](http://nodejs.org) project.

## Quick Start

### Develop

Linux/OSX running [node](http://nodejs.org) v0.6.x, [mongodb](http://mongodb.org) & [redis](http://redis.io)

1. Get the boilerplate:

    ```shell
    mkdir projectname
    git clone git://github.com/hunterloftis/node-boilerplate.git projectname
    cd projectname
    ```

2. Check your system requirements and start local databases:

    ```shell
    scripts/requirements
    redis-server
    mongod
    ```

3. Try it:

    ```shell
    sudo npm install
    sudo node server
    ```

4. _code, code, code_
5. Set up a git repository hosting your project (eg, on Github)

### Provision
  
Ubuntu VPS (eg, [Linode](http://linode.com))

1. Fill out `scripts/deploy.conf` - [more](#configuration)  
2. Put your & other developers' public keys in `scripts/provisioning/keys`
   (these public keys will have root access)
3. Provision your server as root:
  
    ```
    cd scripts
    sudo ./provision staging root
    ```

### Deploy
  
3. Run within /scripts:

    ```
    ./deploy staging setup
    ./deploy -T staging
    ```

<a name="configuration" />
## deploy.conf

A sharp fork of [visionmedia/deploy](https://github.com/visionmedia/deploy) to be used for provisioning *and* deployment.

`deploy(1)` will look for _./deploy.conf_, consisting of one or more environments, `[staging]`, `[production]`, etc, followed by directives.

An example .conf file with all available directives:

```
[production]
project awesome
repo git@github.com:Skookum/awesome.git
host 123.456.789.10
private /keys/awesome.id_rsa
environment production
ref origin/master
stack node

[media]
project awesome_media
repo git@github.com:Skookum/awesome.git
host 123.456.789.11
private /keys/awesome.id_rsa
ref origin/master
stack nginx
```

## Directives

### project

  The name of your project. This is also the username of your deploy user, and the location of your deployed project (/home/$projectname). Avoid using characters other than [a-z] and underscore.

    project better_than_facebook

### repo

  Your git repository. Deploying will pull from this uri as the deploy user, $projectname.

    repo git://github.com/hunterloftis/node-boilerplate.git

### host

  The IP address of your server.

    host 123.456.789.10

### private

  Path to your deploy user's private key. This is necessary if you are using a private git repository. If not, just use /dev/null.

    private /keys/awesome.id_rsa

### environment

  A string that sets NODE_ENV for this project.

    environment staging

### ref

  The default git ref from which to deploy. Defaults to origin/master.

    ref origin/staging

### stack
  
  One of: `node` or `nginx`.
  The stack determines what type of server deployment you'd like to do. Node deploys a node server, while nginx deploys a very simple, fast, static file server that hosts your `app/public` directory. It's designed to deploy media.yoursite.com.

    stack node
