const pg = @cImport({
    @cInclude("postgres.h");
    @cInclude("fmgr.h");
    @cInclude("varatt.h");
    @cInclude("access/hash.h");
});

// Export the `pg` namespace
pub usingnamespace pg;

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

pub fn function_info_v1() callconv(.C) [*c]const pg.Pg_finfo_record {
    const finfo = struct {
        const static: pg.Pg_finfo_record = pg.Pg_finfo_record{
            .api_version = 1,
        };
    };

    return &finfo.static;
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

pub inline fn VARDATA_ANY(PTR: anytype) @TypeOf(if (VARATT_IS_1B(PTR)) VARDATA_1B(PTR) else VARDATA_4B(PTR)) {
    return if (VARATT_IS_1B(PTR)) VARDATA_1B(PTR) else VARDATA_4B(PTR);
}
pub inline fn VARDATA_4B(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_4b, PTR).*.va_4byte.va_data();
}
pub inline fn VARDATA_1B(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b, PTR).*.va_data();
}
pub inline fn VARDATA_1B_E(PTR: anytype) @TypeOf(@import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_data()) {
    return @import("std").zig.c_translation.cast([*c]pg.varattrib_1b_e, PTR).*.va_data();
}
// End of macros that failed to get translated
