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
    (0),
    (1),
    (1000),
    ('17223372036854775808'),  -- Value bigger than int8
    (-100::bigint)
;

SELECT * FROM test1;
