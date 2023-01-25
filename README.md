# PyKMIP docker container

## What is this container ?

This container was created to enable *integration testing* against KMIP.

*Do not use in production*

## How to use this container

### Docker Hub image
I start the container using the following command:


```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 5696:5696 --name kmip altmannmarcelo/kmip:latest
```


### Building local image

Build a local image using the Dockerfile

```
docker build .

. . .
Successfully built 5f1fd412b0e4

```

Then start the container passing the hash id from previous command

```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 5696:5696 --name kmip  5f1fd412b0e4
```

Alternatively, you can pass `-t your_user/image_name#tag` parameter to build command and use that as image ID:

```
docker build -t altmannmarcelo/kmip:latest .
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 5696:5696 --name kmip altmannmarcelo/kmip:latest
```

## Copy Certificates

In order to use kmip, you will have to copy the certificates:


```
mkdir /tmp/certs
docker cp kmip:/opt/certs/root_certificate.pem /tmp/certs/
docker cp kmip:/opt/certs/client_key_jane_doe.pem /tmp/certs/
docker cp kmip:/opt/certs/client_certificate_jane_doe.pem /tmp/certs/
```

## Using with Percona Server (mysql)

In order to use with mysql, you need to configure component_keyring_kmip.cnf with following configuration:

```
mkdir /tmp/certs
docker cp kmip:/opt/certs/root_certificate.pem /tmp/certs/
docker cp kmip:/opt/certs/client_key_jane_doe.pem /tmp/certs/
docker cp kmip:/opt/certs/client_certificate_jane_doe.pem /tmp/certs/
```

## Using with Percona Xtrabackup test suite

In order to run pxb test suite you need to call it with following variables:

```
KMIP_CLIENT_CA="/tmp/certs/client_certificate_jane_doe.pem" KMIP_CLIENT_KEY="/tmp/certs/client_key_jane_doe.pem" KMIP_SERVER_CA="/tmp/certs/root_certificate.pem" ./run.sh
```


## KMIP server logs

To inspect server logs run:

```
docker exec -it kmip tail -f /var/log/pykmip/server.log
```