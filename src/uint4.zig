const std = @import("std");
const pgzx = @import("pgzx");
const uint = @import("./uint.zig");

const uint4 = uint.Uint(u32);

comptime {
    pgzx.PG_FUNCTION_V1("uint4in", uint4.in(10));
    pgzx.PG_FUNCTION_V1("uint4inhex", uint4.in(16));
    pgzx.PG_FUNCTION_V1("uint4out", uint4.out(10));
    pgzx.PG_FUNCTION_V1("uint4outhex", uint4.out(16));
    pgzx.PG_FUNCTION_V1("btuint4uint4cmp", uint4.btCmp);
    pgzx.PG_FUNCTION_V1("btuint4sortsupport", uint4.sortSupport);
    pgzx.PG_FUNCTION_V1("uint4hash", uint4hash);
    pgzx.PG_FUNCTION_V1("uint4receive", uint4.receive);
    pgzx.PG_FUNCTION_V1("uint4send", uint4.send);
    pgzx.PG_FUNCTION_V1("uint4uint4lt", uint4.lt);
    pgzx.PG_FUNCTION_V1("uint4uint4le", uint4.le);
    pgzx.PG_FUNCTION_V1("uint4uint4eq", uint4.eq);
    pgzx.PG_FUNCTION_V1("uint4uint4ne", uint4.ne);
    pgzx.PG_FUNCTION_V1("uint4uint4ge", uint4.ge);
    pgzx.PG_FUNCTION_V1("uint4uint4gt", uint4.gt);
    pgzx.PG_FUNCTION_V1("uint4uint4add", uint4.add);
    pgzx.PG_FUNCTION_V1("uint4uint4sub", uint4.sub);
    pgzx.PG_FUNCTION_V1("uint4uint4multiply", uint4.multiply);
    pgzx.PG_FUNCTION_V1("uint4uint4divide", uint4.divide);
    pgzx.PG_FUNCTION_V1("uint4uint4mod", uint4.mod);
}

fn uint4hash(value: u32) !pgzx.c.Datum {
    return pgzx.c.hash_uint32(value);
}
