# Search Engine
Elasticsearch + MongoDB

## Steps
1. Prepare key by run these commands
```
openssl rand -base64 700 > file.key
chmod 400 file.key
sudo chown 999:999 file.key
```
2. Run
```
docket network create search_engine
docker-compose up -d --remove-orphans
```

## Note
If you want to run with multiple container mongo. Please duplicate serivce mongo-0 with different mapping ports (but keeps the port in docker) and different name
For example
```
 services:
   ...
   mongo-1:
    container_name: mongo-1
    ports:
      - "27018:27017"
    expose: 
      - 27018
```
Then update `setup.sh`: introduce new service and add it into "members"
For example
```
MONGODB1=mongo-0
MONGODB2=mongo-1
```

```
    "members": [
        {
            "_id": 0,
            "host": "${MONGODB1}:27017",
            "priority": 2
        },
        {
            "_id": 1,
            "host": "${MONGODB2}:27017",
            "priority": 2
        },
    ]
```

## Elasticsearch authentication
- Tag `xpack.security.enabled` must be `true`
- And add your username (default is `elastic`: recommend does not change this username) and password
- ![example-request.png](request.png)
- In file `monstache.test.config.toml` enable `elasticsearch-user` + `elasticsearch-password`

## Connect to database
- `mongodb://test:test@ip-server:27017/tempdb?replicaSet=rs0&directConnection=true`
- `mongodb://root:admin@ip-server:27017/?replicaSet=rs0&directConnection=true`

## Helpful
List all indexes
`localhost:9200/_cat/indices`

Check health
`localhost:9200/_cat/health`

List data in indexes
`http://localhost:9200/index_name/_search`
`http://localhost:9200/index_name/_search?q=string`

To solve cluster health: yellow issue

PUT /_settings
{
"index" : {
"number_of_replicas" : 0
}
}