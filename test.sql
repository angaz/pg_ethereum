DROP EXTENSION IF EXISTS pg_ethereum CASCADE;
CREATE EXTENSION pg_ethereum;

DROP TABLE IF EXISTS test1;
CREATE TABLE test1 (
    val1    uint8    PRIMARY KEY
);

INSERT INTO test1
VALUES
    (0::float8),
    (1::numeric),
    (100::bigint),
    (1000::int),
    ('17223372036854775808'),  -- Value bigger than int8
    ('18446744073709551615')   -- Max uint8 (2**64-1)
RETURNING val1;

DROP TABLE IF EXISTS test2;
CREATE TABLE test2 (
    val1    uint4    PRIMARY KEY
);

INSERT INTO test2
VALUES
    (0::float8),
    (1::numeric),
    (1000::int),
    ('4294967295')  -- Max uint4 (2**32-1)
RETURNING val1;

DROP TABLE IF EXISTS test3;
CREATE TABLE test3 (
    val1    uint4hex    PRIMARY KEY
);

INSERT INTO test3
VALUES
    (0::int::uint4),
    (1::int::uint4),
    (100::int::uint4),
    (1000::int::uint4),
    ('ffffffff')  -- Max 4-byte value
RETURNING val1;

DROP TABLE IF EXISTS test4;
CREATE TABLE test4 (
    val1    uint8hex    PRIMARY KEY
);

INSERT INTO test4
VALUES
    (0::int::uint8),
    (1::int::uint8),
    (100::int::uint8),
    (1000::int::uint8),
    ('0a'),
    ('17223372036854775808'::uint8),  -- Value bigger than int8
    ('ffffffffffffffff')   -- Max 8-byte value
RETURNING val1;

DROP TABLE IF EXISTS test5;
CREATE TABLE test5 (
    val1    fork_hash    PRIMARY KEY
);

INSERT INTO test5
VALUES
    (0::int::uint4),
    (1::int::uint4),
    (100::int::uint4),
    (1000::int::uint4),
    ('0a'),
    ('ffffffff')  -- Max 4-byte value
RETURNING val1;
