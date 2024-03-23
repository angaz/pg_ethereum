\set ON_ERROR_STOP on
\pset pager off

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
    (1000::int),
    (100::bigint),
    ('18446744073709551615'),   -- Max uint8 (2**64-1)
    ('17223372036854775808')  -- Value bigger than int8
;

SELECT val1 FROM test1 ORDER BY val1;

DROP TABLE IF EXISTS test2;
CREATE TABLE test2 (
    val1    uint4    PRIMARY KEY
);

INSERT INTO test2
VALUES
    (0::real),
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

DROP TABLE IF EXISTS test6;
CREATE TABLE test6 (
    val1    array32    PRIMARY KEY
);

INSERT INTO test6
VALUES
    ('0000b61bfc9c940169679971368d863aa9fc86c2e52b9629f159064ea87c0d12'),
    ('\x0000c8fc589ad9cdf03f3da718bc57f852a7530eb6b462dfc9c84b6b340f97d5'::bytea)
;

SELECT * FROM test6;

DROP TABLE IF EXISTS test7;
CREATE TABLE test7 (
    val1    array64    PRIMARY KEY
);

INSERT INTO test7
VALUES
    ('e58d0fdd58b20605a1818e6e711ba194d66e8984b922c22c1ba1661c33a99cbe0edc9dd2272c2bdf71729d1b8c620e91826f71ebe50d5b474edb916e8e62b932'),
    ('\xae5094a288c572582eebac79938193459ad40cab8f8f6651a8f0e4a9b0fdc45de3bfd9b272bb1dd3038274d7ea5ca6858136c2a532f19c077e16680033267dd6'::bytea)
;

SELECT * FROM test7;

SELECT pubkey_to_node_id('e58d0fdd58b20605a1818e6e711ba194d66e8984b922c22c1ba1661c33a99cbe0edc9dd2272c2bdf71729d1b8c620e91826f71ebe50d5b474edb916e8e62b932');

SELECT to_string('\x967420302e312e312d616c7068612e312d313130663530'::rlp);
SELECT * FROM decode_single_string('\x967420302e312e312d616c7068612e312d313130663530967420302e312e312d616c7068612e312d313130663530');
SELECT * FROM decode_double_string('\x967420302e312e312d616c7068612e312d313130663530967420302e312e312d616c7068612e313d313130663530');
SELECT * FROM decode_complex('\x967420302e312e312d616c7068612e312d313130663530967420302e312e312d616c7068612e313d313130663530');
