--DROPS
DROP TABLE commitlog;
DROP TABLE itemactivity;
DROP TABLE containeractivity;
DROP TABLE owneditemsbyuser;
DROP TABLE requestsfor;
DROP TABLE requestsby;
DROP TABLE itemrequests;
DROP TABLE itemactivitybytime;
DROP TABLE cleanuplog;

-- TRUNCATES
TRUNCATE commitlog;
TRUNCATE itemactivity;
TRUNCATE containeractivity;
TRUNCATE owneditemsbyuser;
TRUNCATE requestsfor;
TRUNCATE requestsby;
TRUNCATE itemrequests;
TRUNCATE itemactivitybytime;
TRUNCATE cleanuplog;

-- SELECTS
SELECT * FROM commitlog LIMIT 10;
SELECT * FROM itemactivity LIMIT 10;
SELECT * FROM containeractivity LIMIT 10;
SELECT * FROM owneditemsbyuser LIMIT 10;
SELECT * FROM requestsfor LIMIT 10;
SELECT * FROM requestsby LIMIT 10;
SELECT * FROM itemactivitybytime LIMIT 10;
SELECT * FROM cleanuplog LIMIT 10;

-- COUNTS
SELECT COUNT(*) FROM commitlog LIMIT 10000000;
SELECT COUNT(*) FROM itemactivity LIMIT 10000000;
SELECT COUNT(*) FROM containeractivity LIMIT 10000000;
SELECT COUNT(*) FROM owneditemsbyuser LIMIT 10000000;
SELECT COUNT(*) FROM itemrequests LIMIT 10000000;
SELECT COUNT(*) FROM requestsfor LIMIT 10000000;
SELECT COUNT(*) FROM requestsby LIMIT 10000000;
SELECT COUNT(*) FROM itemactivitybytime LIMIT 10000000;
SELECT COUNT(*) FROM cleanuplog LIMIT 10000000;