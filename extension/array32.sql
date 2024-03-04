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
