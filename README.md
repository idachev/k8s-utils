# K8S Utils Image

This image is used to execute various commands in K8S.

It includes:
* Linux utils
* PostgreSQL Client
* etcdctl
* redis-cli

## Building & Push Docker Image

First copy the `.env-tempalte` to `.env` and edit with your info.

You can setup the image name and remote docker registry where to push.

To build and push execute:
```bash
./docker-build.sh
```

## Deploy to K8S

To run a simple pod execute:
```bash
./k8s-run.sh
```

To get the remote bash after pod is running execute:
```bash
./k8s-remote-bash.sh
```

## Using Redis CLI

### Delete  Redis Keys

Go to `redis-cli`:
```bash
redis-cli -h <REDIS IP> -p <REDIS port>
```

In the redis-cli:
```bash
EVAL "return redis.call('del', unpack(redis.call('keys', 'key_prefix_*')))" 0
```
