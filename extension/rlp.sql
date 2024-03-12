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
