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
