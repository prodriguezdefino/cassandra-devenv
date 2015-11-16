CREATE KEYSPACE borrow WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };

USE borrow;

CREATE TABLE commitlog (
containerid uuid,
tstmp timeuuid,
userid text,
action text,
currentflag boolean,
updatable text,
PRIMARY KEY (containerid, tstmp))
WITH CLUSTERING ORDER BY (tstmp DESC);

CREATE TABLE itemactivity (
itemid text,
tstmp timeuuid,
ownerid text,
PRIMARY KEY (itemid, tstmp))
WITH CLUSTERING ORDER BY (tstmp DESC);

CREATE TABLE itemactivitybytime (
containerid uuid,
tstmp timeuuid,
itemid text,
PRIMARY KEY (containerid, tstmp, itemid))
WITH CLUSTERING ORDER BY (tstmp ASC);

CREATE TABLE containeractivity (
containerid uuid,
tstmp timeuuid,
itemid text,
modifiedby text,
action text,
PRIMARY KEY (containerid, tstmp, itemid))
WITH CLUSTERING ORDER BY (tstmp DESC);

CREATE TABLE owneditemsbyuser (
containerid uuid,
ownerid text,
itemid text,
PRIMARY KEY ((containerid, ownerid), itemid));

CREATE TABLE requestsby (
containerid uuid,
userid text,
tstmp timeuuid,
itemid text,
requesteeid text,
PRIMARY KEY ((containerid, userid), tstmp, itemid));

CREATE TABLE requestsfor (
containerid uuid,
userid text,
tstmp timeuuid,
itemid text,
requesterid text,
PRIMARY KEY ((containerid, userid), tstmp, itemid));

CREATE TABLE itemrequests (
itemid text,
tstmp timeuuid,
userid text,
containerid uuid,
requesteeid text,
PRIMARY KEY (itemid, tstmp, userid));

CREATE TABLE cleanuplog (
randate text,
tstmp timeuuid,
logdigest text,
PRIMARY KEY (randate, tstmp))
WITH CLUSTERING ORDER BY (tstmp DESC);

CREATE KEYSPACE data WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'datacenter1' : 1 };

USE data;

CREATE TABLE worksets (
containerid uuid,
worksetid uuid,
itemid text,
name text,
PRIMARY KEY (containerid, worksetid, itemid));

CREATE TABLE items (
containerid uuid,
itemid text,
worksetid uuid,
state text,
name text,
PRIMARY KEY (containerid, itemid));

CREATE TABLE containers (
containerid uuid,
name text,
PRIMARY KEY (containerid));

DESC SCHEMA;