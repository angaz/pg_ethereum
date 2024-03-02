CREATE TYPE uint8;

CREATE FUNCTION uint8in(cstring) RETURNS uint8
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8in';

CREATE FUNCTION uint8out(uint8) RETURNS cstring
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8out';

CREATE TYPE uint8 (
    INPUT = uint8in,
    OUTPUT = uint8out,
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
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint8uint8cmp';

CREATE FUNCTION uint8uint8plus(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8plus';

CREATE OPERATOR + (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    COMMUTATOR = +,
    PROCEDURE = uint8uint8plus
);

CREATE FUNCTION uint8uint8minus(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'uint8uint8minus';

CREATE OPERATOR - (
    LEFTARG = uint8,
    RIGHTARG = uint8,
    PROCEDURE = uint8uint8minus
);

CREATE FUNCTION uint8uint8multiply(uint8, uint8) RETURNS uint8
    IMMUTABLE
    STRICT
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
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'btuint8sortsupport';

CREATE FUNCTION hashuint8(uint8) RETURNS int4
    IMMUTABLE
    STRICT
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'hashuint8';

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
        FUNCTION        1       hashuint8(uint8);

CREATE TYPE uint4;

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

CREATE TYPE uint4 (
    INPUT = uint4in,
    OUTPUT = uint4out,
    INTERNALLENGTH = 4,
    PASSEDBYVALUE,
    ALIGNMENT = int4
);

CREATE CAST (double precision AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (numeric AS uint4) WITH INOUT AS ASSIGNMENT;
CREATE CAST (real AS uint4) WITH INOUT AS ASSIGNMENT;

CREATE CAST (uint4 AS double precision) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS numeric) WITH INOUT AS IMPLICIT;
CREATE CAST (uint4 AS real) WITH INOUT AS IMPLICIT;
