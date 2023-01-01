#!/bin/bash
mongosh -- "$MONGO_INITDB_DATABASE" <<-EOJS
    var user = '$MONGO_INITDB_USERNAME';
    var passwd = '$MONGO_INITDB_PASSWORD';
    db.createUser({user: user, pwd: passwd, roles: ["readWrite"]});
EOJS

{
sleep 15 &&
mongosh --host mongo-0:27017 <<-EOJS
    var rootUser = '$MONGO_INITDB_ROOT_USERNAME';
    var rootPassword = '$MONGO_INITDB_ROOT_PASSWORD';
    var admin = db.getSiblingDB('admin');
    admin.auth(rootUser, rootPassword);
    var cfg = {
        "_id": "${MONGO_REPLICA_SET_NAME}",
        "protocolVersion": 1,
        "version": 1,
        "members": [
            {
                "_id": 0,
                "host": "mongo-0:27017",
                "priority": 2
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.secondaryOk();
    db.getMongo().setReadPref('primary');
    rs.status();
EOJS
} &