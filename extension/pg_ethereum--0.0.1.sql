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


CREATE CAST (double precision AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (numeric AS uint8) WITH INOUT AS ASSIGNMENT;
CREATE CAST (real AS uint8) WITH INOUT AS ASSIGNMENT;

CREATE CAST (uint8 AS double precision) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS numeric) WITH INOUT AS IMPLICIT;
CREATE CAST (uint8 AS real) WITH INOUT AS IMPLICIT;
