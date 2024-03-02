const std = @import("std");
const pg = @import("./pg.zig");

pub inline fn in(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const inStr = pg.getArgCString(fcinfo, 0);

    const value = std.fmt.parseInt(T, inStr, 10) catch |err| {
        switch (err) {
            error.Overflow => pg.error_report(
                pg.ERROR,
                pg.ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE,
                "input too big",
            ),
            error.InvalidCharacter => pg.error_report(
                pg.ERROR,
                pg.ERRCODE_INVALID_TEXT_REPRESENTATION,
                "invalid character",
            ),
        }

        return pg.datumNull();
    };

    return pg.getDatum(value);
}

pub inline fn out(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(T, fcinfo, 0);

    // number of digits + 1 for NULL
    const outLen: usize = switch (value) {
        0...999 => 4,
        1000...9999999 => 8,
        10000000...99999999999 => 12,
        100000000000...999999999999999 => 16,
        else => 21,
    };
    const buf = pg.palloc(outLen) orelse return pg.datumNull();
    const result: []u8 = @as([*c]u8, @ptrCast(buf))[0..outLen];

    const pos = std.fmt.formatIntBuf(result, value, 10, std.fmt.Case.lower, .{});
    @memset(result[pos..], 0);

    return pg.CStringGetDatum(result.ptr);
}

pub inline fn receive(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const msg = pg.getArgPointer(pg.StringInfo, fcinfo, 0);
    const value: T = switch (T) {
        u64 => pg.pq_getmsguint64(msg),
        u32 => pg.pq_getmsgint(msg, 4),
        else => unreachable,
    };

    return pg.getDatum(value);
}

pub inline fn cmp(a: anytype, b: anytype) i32 {
    if (a > b)
        return 1;
    if (a == b)
        return 0;
    return -1;
}
