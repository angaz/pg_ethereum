CREATE TYPE uint4;
CREATE TYPE uint4hex;

CREATE FUNCTION uint4in(cstring) RETURNS uint4
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4in';

CREATE FUNCTION uint4out(uint4) RETURNS cstring
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4out';

CREATE FUNCTION uint4receive(internal) RETURNS uint4
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4receive';

CREATE FUNCTION uint4send(uint4) RETURNS bytea
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4send';

CREATE TYPE uint4 (
    INPUT = uint4in,
    OUTPUT = uint4out,
    RECEIVE = uint4receive,
    SEND = uint4send,
    INTERNALLENGTH = 8,
    PASSEDBYVALUE,
    -- Only value for 8-byte alignment:
    --   search for `or double` to see the available types
    --   https://www.postgresql.org/docs/current/sql-createtype.html
    ALIGNMENT = double
);

CREATE CAST (double precision AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (int AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (numeric AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (real AS uint4) WITH INOUT AS ASSIGNMENT;

CREATE CAST (uint4 AS double precision) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS int) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS numeric) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS real) WITH INOUT AS IMPLICIT;

CREATE FUNCTION uint4uint4lt(uint4, uint4) RETURNS boolean
    IMMUTABLE
    STRICT
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
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint4uint4cmp';

CREATE FUNCTION uint4uint4add(uint4, uint4) RETURNS uint4
    IMMUTABLE
    STRICT
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
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint4sortsupport';

CREATE FUNCTION uint4hash(uint4) RETURNS int4
    IMMUTABLE
    STRICT
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
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4inhex';

CREATE FUNCTION uint4outhex(uint4hex) RETURNS cstring
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint4outhex';

CREATE TYPE uint4hex (
    INPUT = uint4inhex,
    OUTPUT = uint4outhex,
    LIKE = uint4
);
