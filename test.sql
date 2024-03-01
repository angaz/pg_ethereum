DROP EXTENSION IF EXISTS pg_ethereum CASCADE;
CREATE EXTENSION pg_ethereum;

CREATE TABLE test1 (
    val1    uint8    PRIMARY KEY
);

INSERT INTO test1 (
    val1
) VALUES (
    0,
    1,
    1000,
    0xf889ffffffffffff  -- Value bigger than int8
);

SELECT * FROM test1;
