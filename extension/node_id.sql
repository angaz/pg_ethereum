CREATE DOMAIN node_id AS array32;
CREATE DOMAIN pubkey AS array64;

CREATE FUNCTION pubkey_to_node_id(pubkey) RETURNS node_id
    IMMUTABLE
    STRICT
    PARALLEL SAFE
    LANGUAGE C
    AS '$libdir/pg_ethereum', 'pubkey_to_node_id';
