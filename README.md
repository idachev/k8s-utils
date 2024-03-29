# K8S Utils Image

This image is used to execute various commands in K8S.

It includes:
* Linux utils
* PostgreSQL Client
* etcdctl
* redis-cli

## Building & Push Docker Image

First copy the `tempalte.env` to `.env` and edit with your info.

You can setup the image name and remote docker registry where to push.

To build execute:
```bash
./docker-build.sh
```

To push execute:
```bash
./docker-push.sh
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

To remove pod:
```bash
./k8s-remove.sh
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

## Using `simpleproxy`

Let say you have a DB accessible only from the cluster.

You can access it through the `simpleproxy` with this:
```bash
./k8s-remote-exec.sh "simpleproxy -d -L 15432 -R <DB IP>:5432"
```

Redirect the port with kubectl:
```bash
./k8s-port-fwd.sh 15432:15432
```

Then you can connect to the DB with:
```bash
psql -h localhost -p 15432 -U <DB USER> -d <DB NAME>
```

### Playing Elasticsearch

List indexes:
```bash
curl -X GET "elasticsearch:9200/_cat/indices?v&pretty"
```

As json:
```bash
curl -X GET "elasticsearch:9200/_cat/indices?format=json" | jq '.'
```

List 5 documents in an index:
```bash
curl -X GET "elasticsearch:9200/<INDEX>/_search?pretty" -H 'Content-Type: application/json' -d'{"size": 5,"query":{"match_all": {}}}' | jq '.'
```
