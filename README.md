# K8S Utils Image

This image is used to execute various commands in K8S.

It includes:
* Linux utils
* PostgreSQL Client
* etcdctl
* redis-cli

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
