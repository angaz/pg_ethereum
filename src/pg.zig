const std = @import("std");
const pg = @cImport({
    @cInclude("postgres.h");
    @cInclude("access/hash.h");
    @cInclude("executor/executor.h");
    @cInclude("fmgr.h");
    @cInclude("funcapi.h");
    @cInclude("libpq/pqformat.h");
    @cInclude("utils/sortsupport.h");
    @cInclude("varatt.h");
});

// Export the `pg` namespace
pub usingnamespace pg;

pub const FinfoRecord = [*c]const pg.Pg_finfo_record;

pub fn error_report(elevel: c_int, errcode: c_int, errmsg: [:0]const u8) void {
    // pg.pg_prevent_errno_in_scope();

    if (pg.errstart(elevel, 0)) {
        _ = pg.errcode(errcode);
        _ = pg.errmsg(errmsg);

        const src = @src();
        pg.errfinish(src.file, src.line, src.fn_name);
    }
}

// Deserializes a Postgres text value into a Zig slice
pub fn span_text(arg: [*c]pg.text) []u8 {
    return VARDATA_ANY(arg)[0..@intCast(VARSIZE_ANY_EXHDR(arg))];
}

pub inline fn function_info_v1() FinfoRecord {
    const finfo = struct {
        const static: pg.Pg_finfo_record = pg.Pg_finfo_record{
            .api_version = 1,
        };
    };

    return &finfo.static;
}

pub inline fn datumGetValue(comptime T: type, datum: pg.Datum) T {
    switch (T) {
        u32 => return pg.DatumGetUInt32(datum),
        u64 => return pg.DatumGetUInt64(datum),
        else => unreachable,
    }
}

pub inline fn datumGetSlice(comptime len: usize, datum: pg.Datum) []u8 {
    const buf = datumGetPointer([*]u8, datum);
    return buf[0..len];
}

pub inline fn getArgValue(comptime T: type, fcinfo: pg.FunctionCallInfo, n: usize) T {
    return datumGetValue(T, fcinfo.*.args()[n].value);
}

pub inline fn datumNull() pg.Datum {
    return @as(pg.Datum, 0);
}

pub inline fn getDatum(value: anytype) pg.Datum {
    if (@TypeOf(value) == i64) {
        return @as(pg.Datum, @bitCast(value));
    }

    return @as(pg.Datum, @bitCast(@as(u64, value)));
}

pub inline fn getArgCString(fcinfo: pg.FunctionCallInfo, n: usize) []u8 {
    const inStr: [*c]u8 = pg.DatumGetCString(fcinfo.*.args()[n].value);

    return std.mem.span(inStr);
}

pub inline fn datumGetPointer(comptime T: type, datum: pg.Datum) T {
    return @as(T, @ptrCast(@alignCast(pg.DatumGetPointer(datum))));
}

pub inline fn getArgPointer(comptime T: type, fcinfo: pg.FunctionCallInfo, n: usize) T {
    return datumGetPointer(T, fcinfo.*.args()[n].value);
}

pub inline fn getArgSlice(comptime len: usize, fcinfo: pg.FunctionCallInfo, n: usize) []u8 {
    return datumGetSlice(len, fcinfo.*.args()[n].value);
}

pub inline fn getArgBytea(fcinfo: pg.FunctionCallInfo, n: usize) []u8 {
    const bytea = pg.DatumGetByteaP(fcinfo.*.args()[n].value);
    const len = varSize4B(bytea) - pg.VARHDRSZ;

    return varData4B(bytea)[0..len];
}

pub fn pq_getmsguint64(msg: pg.StringInfo) u64 {
    return @bitCast(pg.pq_getmsgint64(msg));
}

pub fn pallocArray(len: usize) ?[]u8 {
    const buf = pg.palloc(len) orelse return null;
    return @as([*c]u8, @ptrCast(buf))[0..len];
}

pub fn pallocBytea(len: usize) ?[*c]pg.bytea {
    const buf = pg.palloc(pg.VARHDRSZ + len) orelse return null;
    setVarSize4B(buf, pg.VARHDRSZ + len);

    return @ptrCast(buf);
}

pub fn sliceToBytea(s: []const u8) ?[*c]pg.bytea {
    const bytea = pallocBytea(s.len) orelse return null;
    @memcpy(varData4B(bytea)[0..s.len], s);

    return bytea;
}

pub fn pallocArrayOf(comptime T: type, len: usize) ?[*c]T {
    const buf = pg.palloc(@sizeOf(T) * len) orelse return null;
    return @as([*c]T, @ptrCast(@alignCast(buf)));
}

// Macros that failed to get translated properly by translate-c, needed for varint deserialization
pub inline fn VARTAG_1B_E(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_tag) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_tag;
}
pub inline fn VARTAG_IS_EXPANDED(tag: anytype) @TypeOf((tag & ~@as(c_uint, 1)) == pg.VARTAG_EXPANDED_RO) {
    return (tag & ~@as(c_uint, 1)) == pg.VARTAG_EXPANDED_RO;
}
pub inline fn VARTAG_SIZE(tag: anytype) usize {
    return if (tag == pg.VARTAG_INDIRECT) @import("std").zig.c_translation.sizeof(pg.varatt_indirect) else if (VARTAG_IS_EXPANDED(tag)) @import("std").zig.c_translation.sizeof(pg.varatt_expanded) else if (tag == pg.VARTAG_ONDISK) @import("std").zig.c_translation.sizeof(pg.varatt_external) else unreachable;
}
pub inline fn VARSIZE_4B(PTR: anytype) @TypeOf((@import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_header >> 2) & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0x3FFFFFFF, .hex)) {
    return (@import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_header >> 2) & @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0x3FFFFFFF, .hex);
}
pub inline fn VARSIZE_1B(PTR: anytype) @TypeOf((@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header >> 1) & @as(c_uint, 0x7F)) {
    return (@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header >> 1) & @as(c_uint, 0x7F);
}
pub inline fn VARATT_IS_1B(PTR: anytype) @TypeOf((@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header & @as(c_uint, 0x01)) == @as(c_uint, 0x01)) {
    return (@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header & @as(c_uint, 0x01)) == @as(c_uint, 0x01);
}
pub inline fn VARATT_IS_1B_E(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header == @as(c_uint, 0x01)) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_header == @as(c_uint, 0x01);
}
pub inline fn VARHDRSZ_EXTERNAL() c_uint {
    return @sizeOf(pg.varattrib_1b_e); // NOTICE: original code used offsetof(pg.varattrib_1b_e, va_data), but va_data gets translated as a function, so it's no longer a field
}
pub inline fn VARHDRSZ_SHORT() c_uint {
    return @sizeOf(pg.varattrib_1b); // NOTICE: original code used offsetof(pg.varattrib_1b_e, va_data), but va_data gets translated as a function, so it's no longer a field
}
pub inline fn VARSIZE_EXTERNAL(PTR: anytype) @TypeOf(VARHDRSZ_EXTERNAL() + VARTAG_SIZE(VARTAG_1B_E(PTR))) {
    return VARHDRSZ_EXTERNAL() + VARTAG_SIZE(VARTAG_1B_E(PTR));
}
fn VARSIZE_ANY_EXHDR(PTR: anytype) @TypeOf(if (VARATT_IS_1B_E(PTR)) VARSIZE_EXTERNAL(PTR) - VARHDRSZ_EXTERNAL() else if (VARATT_IS_1B(PTR)) VARSIZE_1B(PTR) - VARHDRSZ_SHORT() else VARSIZE_4B(PTR) - pg.VARHDRSZ) {
    return if (VARATT_IS_1B_E(PTR)) VARSIZE_EXTERNAL(PTR) - VARHDRSZ_EXTERNAL() else if (VARATT_IS_1B(PTR)) VARSIZE_1B(PTR) - VARHDRSZ_SHORT() else VARSIZE_4B(PTR) - pg.VARHDRSZ;
}
pub inline fn setVarSize4B(PTR: anytype, len: usize) void {
    std.zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_header = (@as(c_uint, @intCast(len)) << 2) & 0x3FFFFFFF;
}
pub inline fn varSize4B(PTR: anytype) u32 {
    return std.zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_header >> 2;
}

pub inline fn VARDATA_ANY(PTR: anytype) @TypeOf(if (VARATT_IS_1B(PTR)) VARDATA_1B(PTR) else VARDATA_4B(PTR)) {
    return if (VARATT_IS_1B(PTR)) VARDATA_1B(PTR) else VARDATA_4B(PTR);
}
pub inline fn VARDATA_4B(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_data();
}
pub inline fn varData4B(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_data()) {
    return VARDATA_4B(PTR);
}
pub inline fn VARDATA_1B(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_data();
}
pub inline fn VARDATA_1B_E(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_data();
}
// End of macros that failed to get translated
