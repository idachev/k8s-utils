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
./docker-build.sh u24.04-k8su-1.0
```

To push execute:
```bash
./docker-push.sh u24.04-k8su-1.0
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

## Using HTTP Proxy

You can use the pod as an HTTP proxy to make requests as if you're inside the cluster. This is useful for accessing internal services, APIs, or testing connectivity from within the cluster network.

### Quick Start

Run the HTTP proxy setup script:
```bash
./k8s-http-proxy.sh
```

This will:
1. Start tinyproxy in the pod (if not already running)
2. Forward port 8888 from the pod to your local machine
3. Display instructions for using the proxy

### Using the Proxy

Once the proxy is running, configure your HTTP client to use it:

```bash
# Set environment variables
export http_proxy=http://localhost:8888
export https_proxy=http://localhost:8888

# Now all HTTP/HTTPS requests will go through the pod
curl https://internal-service.cluster.local
wget http://private-api.namespace.svc.cluster.local/api/health
```

Or use it directly with curl:
```bash
curl -x http://localhost:8888 https://internal-service.cluster.local
```

### Custom Ports

You can specify custom ports:
```bash
# Use different proxy port in pod and local port
./k8s-http-proxy.sh 8888 9090  # pod_port local_port

# Then use localhost:9090 as your proxy
export http_proxy=http://localhost:9090
```

### Stopping the Proxy

Press `Ctrl+C` to stop the port forwarding. The tinyproxy service will continue running in the pod.

To stop tinyproxy in the pod:
```bash
./k8s-http-proxy-stop.sh
```

Or manually:
```bash
./k8s-remote-exec.sh "pkill tinyproxy"
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
