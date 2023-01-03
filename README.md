# Discourse Docker file for TF discourse flist


## What is Discourse&reg;?

> Discourse is an open source discussion platform with built-in moderation and governance systems that let discussion communities protect themselves from bad actors even without official moderators.

[Overview of Discourse&reg;](http://www.discourse.org/)

## Why We Used Bitnami Images?

- The main reason here to choose Bitnami image vs the official one that Bitnami image is pre-bootstrapped image which minimize the time required at the solution start up.
- Bitnami closely tracks upstream source changes and promptly publishes new versions so the latest bug fixes and features are available as soon as possible.

check project updates [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

this repo forked from Bitnami image [Docker Hub Registry](https://hub.docker.com/r/bitnami/discourse).

## How to build and use this image

```bash
docker build -t tf-discourse-aio:latest .
docker run --name tf-discourse -p 80:3000 --env-file flist.env tf-discourse-aio:latest
```

Access your application at `http://localhost/`

### Troubleshooting discourse

If you need to run discourse administrative commands like [Create admin account from console](https://meta.discourse.org/t/create-admin-account-from-console/17274), you can do so by executing a shell inside the container and running with the proper environment variables.

```
cd /opt/bitnami/discourse
RAILS_ENV=production bundle exec rake admin:create
```

## Configuration

### Configuration files

You can mount your configuration files to the `/opt/bitnami/discourse/mounted-conf` directory. Make sure that your configuration files follow the standardized names used by Discourse. Some of the most common files include:

- `discourse.conf`
- `database.yml`
- `site_settings.yml`

The set of default standard configuration files may be found [here](https://github.com/discourse/discourse/tree/master/config). You may refer to the the Discourse [webpage](https://www.discourse.org/) for further details and specific configuration guides.

### Environment variables

When you start the Discourse image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

- For manual execution add a `--env` option with each variable and value:

    ```console
    $ docker run -d --name tf-discourse-aio -p 80:3000 \
      --env DISCOURSE_PASSWORD=my_password \
      --network discourse-tier \
      --volume /path/to/discourse-persistence:/bitnami \
      threefolddev/discourse-aio:latest
    ```

Available environment variables:

##### User and Site configuration

- `DISCOURSE_ENABLE_HTTPS`: Whether to use HTTPS by default. Default: **no**
- `DISCOURSE_EXTERNAL_HTTP_PORT_NUMBER`: Port to used by Discourse to generate URLs and links when accessing using HTTP. Will be ignored if multisite mode is not enabled. Default **80**
- `DISCOURSE_EXTERNAL_HTTPS_PORT_NUMBER`: Port to used by Discourse to generate URLs and links when accessing using HTTPS. Will be ignored if multisite mode is not enabled. Default **443**
- `DISCOURSE_USERNAME`: Discourse application username. Default: **user**
- `DISCOURSE_PASSWORD`: Discourse application password. Default: **bitnami123**
- `DISCOURSE_EMAIL`: Discourse application email. Default: **user@example.com**
- `DISCOURSE_FIRST_NAME`: Discourse user first name. Default: **UserName**
- `DISCOURSE_LAST_NAME`: Discourse user last name. Default: **LastName**
- `DISCOURSE_SITE_NAME`: Discourse site name. Default: **My site!**
- `DISCOURSE_HOST`: Discourse hostname to create application URLs for features such as email notifications and emojis. It can be either an IP or a domain. Default: **www.example.com**
- `DISCOURSE_PRECOMPILE_ASSETS`: Whether to precompile assets during the initialization. Required when installing plugins. Default: **yes**
- `DISCOURSE_EXTRA_CONF_CONTENT`: Extra configuration to append to the `discourse.conf` configuration file. No defaults.
- `DISCOURSE_PASSENGER_SPAWN_METHOD`: Passenger method used for spawning application processes. Valid values: direct, smart. Default: **direct**
- `DISCOURSE_PASSENGER_EXTRA_FLAGS`: Extra flags to pass to the Passenger start command. No defaults.
- `DISCOURSE_PORT_NUMBER`: Port number in which Discourse will run. Default: **3000**
- `DISCOURSE_ENV`: Discourse environment mode. Allowed values: *development*, *production*, *test*. Default: **production**
- `DISCOURSE_ENABLE_CONF_PERSISTENCE`: Whether to enable persistence of the Discourse `discourse.conf` configuration file. Default: **no**
- `DISCOURSE_SKIP_BOOTSTRAP`: Whether to skip performing the initial bootstrapping for the application. This is necessary in case you use a database that already has Discourse data. Default: **no**

##### Passenger configuration
This environment variable changes Passenger Standalone's behavior
see [here](https://www.phusionpassenger.com/library/config/standalone/reference/) for full Passenger config reference.
- `PASSENGER_COMPILE_NATIVE_SUPPORT_BINARY` : Allow compiling Passenger Native Support if binaries wasn't found. make sure `libz-dev` is installed otherwise compiling may fail. Default: **1**
- `PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY` : Allow downloading Passenger Native Support if binaries wasn't found. make sure `wget` or `curl` are available. Default: **1**
- `PASSENGER_ADDRESS`: Instructs Passenger to listen for requests on the given IP address. This means that Passenger will only be able to accept requests that are sent to that IP address. Default: **0.0.0.0**
- `PASSENGER_LOG_LEVEL` : Allows one to specify how much information Passenger should write to the log file. A higher log level value means that more information will be logged. Possible values are: `0` to `7`. Default: **3**
##### Database connection configuration

- `DISCOURSE_DATABASE_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
- `DISCOURSE_DATABASE_PORT_NUMBER`: Port used by the PostgreSQL server. Default: **5432**
- `DISCOURSE_DATABASE_NAME`: Database name that Discourse will use to connect with the database. Default: **bitnami_discourse**
- `DISCOURSE_DATABASE_USER`: Database user that Discourse will use to connect with the database. Default: **bn_discourse**
- `DISCOURSE_DATABASE_PASSWORD`: Database password that Discourse will use to connect with the database. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### Redis connection configuration

- `DISCOURSE_REDIS_HOST`: Hostname for Redis(R). Default: **redis**
- `DISCOURSE_REDIS_PORT_NUMBER`: Port used by Redis(R). Default: **6379**
- `DISCOURSE_REDIS_PASSWORD`: Password for Redis(R).
- `DISCOURSE_REDIS_USE_SSL`: Whether to enable SSL for Redis(R). Default: **no**

##### Create a database for Discourse using postgresql-client

- `POSTGRESQL_CLIENT_DATABASE_HOST`: Hostname for the PostgreSQL server. Default: **postgresql**
- `POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER`: Port used by the PostgreSQL server. Default: **5432**
- `POSTGRESQL_CLIENT_POSTGRES_USER`: Database admin user. Default: **root**
- `POSTGRESQL_CLIENT_POSTGRES_PASSWORD`: Database password for the database admin user. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES`: List of new databases to be created by the postgresql-client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_USER`: New database user to be created by the postgresql-client module. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD`: Database password for the `POSTGRESQL_CLIENT_CREATE_DATABASE_USER` user. No defaults.
- `POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS`: PostgreSQL extensions to enable in the specified database during the first initialization. No defaults.
- `POSTGRESQL_CLIENT_EXECUTE_SQL`: SQL code to execute in the PostgreSQL server. No defaults.
- `ALLOW_EMPTY_PASSWORD`: It can be used to allow blank passwords. Default: **no**

##### SMTP Configuration

To configure Discourse to send email using SMTP you can set the following environment variables:

- `DISCOURSE_SMTP_HOST`: SMTP host.
- `DISCOURSE_SMTP_PORT`: SMTP port.
- `DISCOURSE_SMTP_USER`: SMTP account user.
- `DISCOURSE_SMTP_PASSWORD`: SMTP account password.
- `DISCOURSE_SMTP_PROTOCOL`: If specified, SMTP protocol to use. Allowed values: tls, ssl. No default.
- `DISCOURSE_SMTP_AUTH`: SMTP authentication method. Allowed values: *login*, *plain*, *cram_md5*. Default: **login**.

#### Examples

##### SMTP configuration using a Gmail account

This would be an example of SMTP configuration using a Gmail account:

- Modify the environment variables used for the `discourse` and `sidekiq` containers in the [`docker-compose.yml`](https://github.com/bitnami/containers/blob/main/bitnami/discourse/docker-compose.yml) file present in this repository:

    ```yaml
      discourse:
        ...
        environment:
          ...
          - DISCOURSE_SMTP_HOST=smtp.gmail.com
          - DISCOURSE_SMTP_PORT=587
          - DISCOURSE_SMTP_USER=your_email@gmail.com
          - DISCOURSE_SMTP_PASSWORD=your_password
          - DISCOURSE_SMTP_PROTOCOL=tls
      ...
      sidekiq:
        ...
        environment:
          ...
          - DISCOURSE_SMTP_HOST=smtp.gmail.com
          - DISCOURSE_SMTP_PORT=587
          - DISCOURSE_SMTP_USER=your_email@gmail.com
          - DISCOURSE_SMTP_PASSWORD=your_password
          - DISCOURSE_SMTP_PROTOCOL=tls
      ...
    ```

- For manual execution:

    - First, create the Discourse container:

        ```console
        $ docker run -d --name discourse -p 80:8080 -p 443:8443 \
          --env DISCOURSE_DATABASE_USER=bn_discourse \
          --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
          --env DISCOURSE_SMTP_HOST=smtp.gmail.com \
          --env DISCOURSE_SMTP_PORT=587 \
          --env DISCOURSE_SMTP_USER=your_email@gmail.com \
          --env DISCOURSE_SMTP_PASSWORD=your_password \
          --env DISCOURSE_SMTP_PROTOCOL=tls \
          --network discourse-tier \
          --volume /path/to/discourse-persistence:/bitnami \
          bitnami/discourse:latest
        ```

    - Then, create the Sidekiq container:

        ```console
        $ docker run -d --name sidekiq \
          --env DISCOURSE_DATABASE_USER=bn_discourse \
          --env DISCOURSE_DATABASE_NAME=bitnami_discourse \
          --env DISCOURSE_SMTP_HOST=smtp.gmail.com \
          --env DISCOURSE_SMTP_PORT=587 \
          --env DISCOURSE_SMTP_USER=your_email@gmail.com \
          --env DISCOURSE_SMTP_PASSWORD=your_password \
          --env DISCOURSE_SMTP_PROTOCOL=tls \
          --network discourse-tier \
          --volume /path/to/discourse-persistence:/bitnami \
          bitnami/discourse:latest
        ```

In order to verify your configuration works properly, you can test your configuration parameters from the container itself.

```console
$ docker run -u root -it bitnami/discourse:latest bash
$ install_packages swaks
$ swaks --to your_email@domain.com --from your_email@domain.com --server your.smtp.server.com --auth LOGIN --auth-user your_email@domain.com -tls
```

See the [documentation on troubleshooting SMTP issues](https://docs.bitnami.com/general/how-to/troubleshoot-smtp-issues/) if there are problems.

## Logging

The Discourse Docker image sends the app logs to `stdout`. To view the logs:

```console
$ zinit log discourse
```

## Maintenance

### Backing up your container

To backup your data, make a copy of `/bitnami/discourse`, `/bitnami/redis`, `/bitnami/postgresql`

### Restarting Discourse on Passenger Standalone

Passenger supplies several ways to restart an application that is running in Passenger. This [guide](https://www.phusionpassenger.com/library/admin/standalone/restart_app.html) explains how you can restart applications on Passenger.
