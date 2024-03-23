const std = @import("std");
const pgzx = @import("pgzx");
const uint = @import("./uint.zig");

const uint8 = uint.Uint(u64);

comptime {
    pgzx.PG_FUNCTION_V1("uint8in", uint8.in(10));
    pgzx.PG_FUNCTION_V1("uint8inhex", uint8.in(16));
    pgzx.PG_FUNCTION_V1("uint8out", uint8.out(10));
    pgzx.PG_FUNCTION_V1("uint8outhex", uint8.out(16));
    pgzx.PG_FUNCTION_V1("btuint8uint8cmp", uint8.btCmp);
    pgzx.PG_FUNCTION_V1("btuint8sortsupport", uint8.sortSupport);
    pgzx.PG_FUNCTION_V1("uint8hash", uint8hash);
    pgzx.PG_FUNCTION_V1("uint8receive", uint8.receive);
    pgzx.PG_FUNCTION_V1("uint8send", uint8.send);
    pgzx.PG_FUNCTION_V1("uint8uint8lt", uint8.lt);
    pgzx.PG_FUNCTION_V1("uint8uint8le", uint8.le);
    pgzx.PG_FUNCTION_V1("uint8uint8eq", uint8.eq);
    pgzx.PG_FUNCTION_V1("uint8uint8ne", uint8.ne);
    pgzx.PG_FUNCTION_V1("uint8uint8ge", uint8.ge);
    pgzx.PG_FUNCTION_V1("uint8uint8gt", uint8.gt);
    pgzx.PG_FUNCTION_V1("uint8uint8add", uint8.add);
    pgzx.PG_FUNCTION_V1("uint8uint8sub", uint8.sub);
    pgzx.PG_FUNCTION_V1("uint8uint8multiply", uint8.multiply);
    pgzx.PG_FUNCTION_V1("uint8uint8divide", uint8.divide);
    pgzx.PG_FUNCTION_V1("uint8uint8mod", uint8.mod);
}

pub fn uint8hash(value: u64) !pgzx.c.Datum {
    const lo: u32 = @truncate(value);
    const hi: u32 = @truncate(value >> 32);

    return pgzx.c.hash_uint32(lo ^ hi);
}
