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

## Using ETCD CLI

Check these:
* https://etcd.io/docs/v3.4/dev-guide/interacting_v3/
* https://lzone.de/cheat-sheet/etcd

## Using Redis CLI

Check these:
* https://redis.io/docs/manual/cli/
* https://lzone.de/cheat-sheet/Redis
* https://www.tutorialspoint.com/redis/redis_commands.htm

Go to `redis-cli` console with:
```bash
redis-cli -h <REDIS IP> -p <REDIS port>
```

All following commands are in the redis-cli.

### List Redis Keys

To list all keys:
```bash
KEYS *
```

To list keys starting with:
```bash
KEYS prefix*
```

### Delete Redis Keys

```bash
EVAL "return redis.call('del', unpack(redis.call('keys', 'key_prefix_*')))" 0
```
