DROP EXTENSION IF EXISTS pg_ethereum CASCADE;
CREATE EXTENSION pg_ethereum;

DROP TABLE IF EXISTS test1;
CREATE TABLE test1 (
    val1    uint8    PRIMARY KEY
);

INSERT INTO test1 (
    val1
)
VALUES
    (0::numeric),
    (1::numeric),
    (1000::numeric),
    (17909126868192198655::numeric);  -- Value bigger than int8

SELECT * FROM test1;
