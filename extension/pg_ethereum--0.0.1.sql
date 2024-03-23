--- uint4

CREATE TYPE uint4;
CREATE TYPE uint4hex;

CREATE FUNCTION uint4in(cstring) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4in';

CREATE FUNCTION uint4out(uint4) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4out';

CREATE FUNCTION uint4receive(internal) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4receive';

CREATE FUNCTION uint4send(uint4) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4send';

CREATE TYPE uint4 (
    INPUT = uint4in,
    OUTPUT = uint4out,
    RECEIVE = uint4receive,
    SEND = uint4send,
    INTERNALLENGTH = 4,
    PASSEDBYVALUE,
    -- Only value for 8-byte alignment:
    --   search for `or double` to see the available types
    --   https://www.postgresql.org/docs/current/sql-createtype.html
    ALIGNMENT = int4
);

CREATE CAST (int AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (numeric AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (real AS uint4) WITH INOUT AS ASSIGNMENT;

CREATE CAST (uint4 AS int) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS numeric) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS real) WITH INOUT AS IMPLICIT;

CREATE FUNCTION uint4uint4lt(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4lt';

CREATE OPERATOR < (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = uint4uint4lt
);

CREATE FUNCTION uint4uint4le(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4le';

CREATE OPERATOR <= (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = uint4uint4le
);

CREATE FUNCTION uint4uint4eq(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4eq';

CREATE OPERATOR = (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = =,
    NEGATOR = <>,
    RESTRICT = eqsel,
    JOIN = eqjoinsel,
    HASHES,
    MERGES,
    PROCEDURE = uint4uint4eq
);

CREATE FUNCTION uint4uint4ne(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4ne';

CREATE OPERATOR <> (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel,
    PROCEDURE = uint4uint4ne
);

CREATE FUNCTION uint4uint4ge(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4ge';

CREATE OPERATOR >= (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = uint4uint4ge
);

CREATE FUNCTION uint4uint4gt(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4gt';

CREATE OPERATOR > (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = uint4uint4gt
);

CREATE FUNCTION btuint4uint4cmp(uint4, uint4) RETURNS integer
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint4uint4cmp';

CREATE FUNCTION uint4uint4add(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4add';

CREATE OPERATOR + (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = +,
    PROCEDURE = uint4uint4add
);

CREATE FUNCTION uint4uint4sub(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4sub';

CREATE OPERATOR - (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    PROCEDURE = uint4uint4sub
);

CREATE FUNCTION uint4uint4multiply(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4multiply';

CREATE OPERATOR * (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    COMMUTATOR = *,
    PROCEDURE = uint4uint4multiply
);

CREATE FUNCTION uint4uint4divide(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4divide';

CREATE OPERATOR / (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    PROCEDURE = uint4uint4divide
);

CREATE FUNCTION mod(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4uint4mod';

CREATE OPERATOR % (
    LEFTARG = uint4,
    RIGHTARG = uint4,
    PROCEDURE = mod
);

CREATE FUNCTION btuint4sortsupport(internal) RETURNS void
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint4sortsupport';

CREATE FUNCTION uint4hash(uint4) RETURNS int4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4hash';

CREATE OPERATOR CLASS uint4_ops
    DEFAULT FOR TYPE uint4 USING btree FAMILY integer_ops AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       btuint4uint4cmp(uint4, uint4),
        FUNCTION        2       btuint4sortsupport(internal);

CREATE OPERATOR CLASS uint4_ops
    DEFAULT FOR TYPE uint4 USING hash FAMILY integer_ops AS
        OPERATOR        1       =,
        FUNCTION        1       uint4hash(uint4);

CREATE FUNCTION uint4inhex(cstring) RETURNS uint4hex
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4inhex';

CREATE FUNCTION uint4outhex(uint4hex) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4outhex';

CREATE TYPE uint4hex (
    INPUT = uint4inhex,
    OUTPUT = uint4outhex,
    LIKE = uint4
);

CREATE CAST (uint4 AS uint4hex) WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (uint4hex AS uint4) WITHOUT FUNCTION AS IMPLICIT;
--- uint8

CREATE TYPE uint8;
CREATE TYPE uint8hex;

CREATE FUNCTION uint8in(cstring) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8in';

CREATE FUNCTION uint8out(uint8) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8out';

CREATE FUNCTION uint8receive(internal) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8receive';

CREATE FUNCTION uint8send(uint8) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8send';

CREATE TYPE uint8 (
    INPUT = uint8in,
    OUTPUT = uint8out,
    RECEIVE = uint8receive,
    SEND = uint8send,
    INTERNALLENGTH = 8,
    PASSEDBYVALUE,
    -- Only value for 8-byte alignment:
    --   search for `or double` to see the available types
    --   https://www.postgresql.org/docs/current/sql-createtype.html
    ALIGNMENT = double
);

CREATE CAST (bigint AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (double precision AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (int AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (numeric AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (real AS uint8) WITH INOUT AS ASSIGNMENT;

CREATE CAST (uint8 AS bigint) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS double precision) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS int) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS numeric) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS real) WITH INOUT AS IMPLICIT;

CREATE FUNCTION uint8uint8lt(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8lt';

CREATE OPERATOR < (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = uint8uint8lt
);

CREATE FUNCTION uint8uint8le(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8le';

CREATE OPERATOR <= (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = uint8uint8le
);

CREATE FUNCTION uint8uint8eq(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8eq';

CREATE OPERATOR = (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = =,
    NEGATOR = <>,
    RESTRICT = eqsel,
    JOIN = eqjoinsel,
    HASHES,
    MERGES,
    PROCEDURE = uint8uint8eq
);

CREATE FUNCTION uint8uint8ne(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8ne';

CREATE OPERATOR <> (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel,
    PROCEDURE = uint8uint8ne
);

CREATE FUNCTION uint8uint8ge(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8ge';

CREATE OPERATOR >= (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = uint8uint8ge
);

CREATE FUNCTION uint8uint8gt(uint8, uint8) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8gt';

CREATE OPERATOR > (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = uint8uint8gt
);

CREATE FUNCTION btuint8uint8cmp(uint8, uint8) RETURNS integer
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint8uint8cmp';

CREATE FUNCTION uint8uint8add(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8add';

CREATE OPERATOR + (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = +,
    PROCEDURE = uint8uint8add
);

CREATE FUNCTION uint8uint8sub(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8sub';

CREATE OPERATOR - (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    PROCEDURE = uint8uint8sub
);

CREATE FUNCTION uint8uint8multiply(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8multiply';

CREATE OPERATOR * (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = *,
    PROCEDURE = uint8uint8multiply
);

CREATE FUNCTION uint8uint8divide(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8divide';

CREATE OPERATOR / (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    PROCEDURE = uint8uint8divide
);

CREATE FUNCTION mod(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8mod';

CREATE OPERATOR % (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    PROCEDURE = mod
);

CREATE FUNCTION btuint8sortsupport(internal) RETURNS void
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint8sortsupport';

CREATE FUNCTION uint8hash(uint8) RETURNS int4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8hash';

CREATE OPERATOR CLASS uint8_ops
    DEFAULT FOR TYPE uint8 USING btree FAMILY integer_ops AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       btuint8uint8cmp(uint8, uint8),
        FUNCTION        2       btuint8sortsupport(internal);

CREATE OPERATOR CLASS uint8_ops
    DEFAULT FOR TYPE uint8 USING hash FAMILY integer_ops AS
        OPERATOR        1       =,
        FUNCTION        1       uint8hash(uint8);

CREATE FUNCTION uint8inhex(cstring) RETURNS uint8hex
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8inhex';

CREATE FUNCTION uint8outhex(uint8hex) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8outhex';

CREATE TYPE uint8hex (
    INPUT = uint8inhex,
    OUTPUT = uint8outhex,
    LIKE = uint8
);

CREATE CAST (uint8 AS uint8hex) WITHOUT FUNCTION AS ASSIGNMENT;
CREATE CAST (uint8hex AS uint8) WITHOUT FUNCTION AS IMPLICIT;
--- fork_hash

CREATE DOMAIN fork_hash AS uint4hex;
--- array32

CREATE TYPE array32;

CREATE FUNCTION array32in(cstring) RETURNS array32
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32in';

CREATE FUNCTION array32out(array32) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32out';

CREATE FUNCTION array32receive(internal) RETURNS array32
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32receive';

CREATE FUNCTION array32send(array32) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32send';

CREATE TYPE array32 (
    INPUT = array32in,
    OUTPUT = array32out,
    RECEIVE = array32receive,
    SEND = array32send,
    INTERNALLENGTH = 32,
    ALIGNMENT = int4
);

CREATE FUNCTION array32tobytea(array32) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32tobytea';

CREATE FUNCTION byteatoarray32(bytea) RETURNS array32
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'byteatoarray32';

CREATE CAST (bytea AS array32) WITH FUNCTION byteatoarray32 AS ASSIGNMENT;
CREATE CAST (array32 AS bytea) WITH FUNCTION array32tobytea AS IMPLICIT;

CREATE FUNCTION array32lt(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32lt';

CREATE OPERATOR < (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = array32lt
);

CREATE FUNCTION array32le(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32le';

CREATE OPERATOR <= (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = array32le
);

CREATE FUNCTION array32eq(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32eq';

CREATE OPERATOR = (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = =,
    NEGATOR = <>,
    RESTRICT = eqsel,
    JOIN = eqjoinsel,
    HASHES,
    MERGES,
    PROCEDURE = array32eq
);

CREATE FUNCTION array32ne(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32ne';

CREATE OPERATOR <> (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel,
    PROCEDURE = array32ne
);

CREATE FUNCTION array32ge(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32ge';

CREATE OPERATOR >= (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = array32ge
);

CREATE FUNCTION array32gt(array32, array32) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32gt';

CREATE OPERATOR > (
    LEFTARG = array32,
    RIGHTARG = array32,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = array32gt
);

CREATE FUNCTION btarray32cmp(array32, array32) RETURNS integer
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btarray32cmp';

CREATE FUNCTION btarray32sortsupport(internal) RETURNS void
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btarray32sortsupport';

CREATE FUNCTION array32hash(array32) RETURNS int4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array32hash';

CREATE OPERATOR CLASS array32_ops
    DEFAULT FOR TYPE array32 USING btree FAMILY integer_ops AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       btarray32cmp(array32, array32),
        FUNCTION        2       btarray32sortsupport(internal);

CREATE OPERATOR CLASS array32_ops
    DEFAULT FOR TYPE array32 USING hash FAMILY integer_ops AS
        OPERATOR        1       =,
        FUNCTION        1       array32hash(array32);
--- array64

CREATE TYPE array64;

CREATE FUNCTION array64in(cstring) RETURNS array64
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64in';

CREATE FUNCTION array64out(array64) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64out';

CREATE FUNCTION array64receive(internal) RETURNS array64
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64receive';

CREATE FUNCTION array64send(array64) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64send';

CREATE TYPE array64 (
    INPUT = array64in,
    OUTPUT = array64out,
    RECEIVE = array64receive,
    SEND = array64send,
    INTERNALLENGTH = 64,
    ALIGNMENT = int4
);

CREATE FUNCTION array64tobytea(array64) RETURNS bytea
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64tobytea';

CREATE FUNCTION byteatoarray64(bytea) RETURNS array64
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'byteatoarray64';

CREATE CAST (bytea AS array64) WITH FUNCTION byteatoarray64 AS ASSIGNMENT;
CREATE CAST (array64 AS bytea) WITH FUNCTION array64tobytea AS IMPLICIT;

CREATE FUNCTION array64lt(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64lt';

CREATE OPERATOR < (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = array64lt
);

CREATE FUNCTION array64le(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64le';

CREATE OPERATOR <= (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel,
    PROCEDURE = array64le
);

CREATE FUNCTION array64eq(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64eq';

CREATE OPERATOR = (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = =,
    NEGATOR = <>,
    RESTRICT = eqsel,
    JOIN = eqjoinsel,
    HASHES,
    MERGES,
    PROCEDURE = array64eq
);

CREATE FUNCTION array64ne(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64ne';

CREATE OPERATOR <> (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel,
    PROCEDURE = array64ne
);

CREATE FUNCTION array64ge(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64ge';

CREATE OPERATOR >= (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = array64ge
);

CREATE FUNCTION array64gt(array64, array64) RETURNS boolean
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64gt';

CREATE OPERATOR > (
    LEFTARG = array64,
    RIGHTARG = array64,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel,
    PROCEDURE = array64gt
);

CREATE FUNCTION btarray64cmp(array64, array64) RETURNS integer
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btarray64cmp';

CREATE FUNCTION btarray64sortsupport(internal) RETURNS void
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btarray64sortsupport';

CREATE FUNCTION array64hash(array64) RETURNS int4
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'array64hash';

CREATE OPERATOR CLASS array64_ops
    DEFAULT FOR TYPE array64 USING btree FAMILY integer_ops AS
        OPERATOR        1       < ,
        OPERATOR        2       <= ,
        OPERATOR        3       = ,
        OPERATOR        4       >= ,
        OPERATOR        5       > ,
        FUNCTION        1       btarray64cmp(array64, array64),
        FUNCTION        2       btarray64sortsupport(internal);

CREATE OPERATOR CLASS array64_ops
    DEFAULT FOR TYPE array64 USING hash FAMILY integer_ops AS
        OPERATOR        1       =,
        FUNCTION        1       array64hash(array64);
--- node_id

CREATE DOMAIN node_id AS array32;
CREATE DOMAIN pubkey AS array64;

CREATE FUNCTION pubkey_to_node_id(pubkey) RETURNS node_id
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'pubkey_to_node_id';
--- rlp

CREATE TYPE rlp;

CREATE FUNCTION rlpin(cstring) RETURNS rlp
    LANGUAGE internal
    IMMUTABLE
    PARALLEL SAFE
    STRICT
    AS 'byteain';

CREATE FUNCTION rlpout(rlp) RETURNS cstring
    LANGUAGE internal
    IMMUTABLE
    PARALLEL SAFE
    STRICT
    AS 'byteaout';

CREATE TYPE rlp (
    INPUT = rlpin,
    OUTPUT = rlpout,
    LIKE = bytea
);

CREATE FUNCTION rlp_decode_int64(rlp) RETURNS int8
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_int64';

CREATE FUNCTION rlp_decode_text(rlp) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_text';

CREATE FUNCTION to_string(rlp) RETURNS cstring
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_text';

CREATE CAST (bytea AS rlp) WITH INOUT AS ASSIGNMENT;
CREATE CAST (rlp AS int8) WITH FUNCTION rlp_decode_int64 AS ASSIGNMENT;

CREATE TYPE double_string AS (
    t    text,
    u    text
);

CREATE TYPE single_string AS (
    t    text
);

CREATE TYPE rlp_complex AS (
    t    text,
    u    int8
);

CREATE FUNCTION decode_single_string(rlp) RETURNS single_string
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_record';

CREATE FUNCTION decode_double_string(rlp) RETURNS double_string
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_record';

CREATE FUNCTION decode_complex(rlp) RETURNS rlp_complex
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'rlp_decode_record';
