const std = @import("std");
const pg = @import("./pg.zig");

pub inline fn in(comptime T: type, comptime base: u8, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const inStr = pg.getArgCString(fcinfo, 0);

    const value = std.fmt.parseInt(T, inStr, base) catch |err| {
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

pub inline fn out(comptime T: type, comptime base: u8, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(T, fcinfo, 0);

    // number of digits + 1 for NULL
    const outLen: usize = switch (base) {
        10 => switch (@as(u64, value)) {
            0...999 => 4,
            1000...9999999 => 8,
            10000000...99999999999 => 12,
            100000000000...999999999999999 => 16,
            else => 21,
        },
        16 => @sizeOf(T) * 2 + 1,
        else => unreachable,
    };

    const result = pg.pallocArray(outLen) orelse return pg.datumNull();

    const pos = std.fmt.formatIntBuf(result, value, base, std.fmt.Case.lower, .{});
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

pub inline fn send(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(T, fcinfo, 0);
    const msg: pg.StringInfo = undefined;

    pg.pq_begintypsend(msg);

    switch (T) {
        u64 => pg.pq_sendint64(msg, value),
        u32 => pg.pq_sendint32(msg, value),
        else => unreachable,
    }

    const bytea = pg.pq_endtypsend(msg);

    return pg.PointerGetDatum(bytea);
}

pub fn makeBTreeFastCMP(comptime T: type) fn (pg.Datum, pg.Datum, pg.SortSupport) callconv(.C) i32 {
    const func = struct {
        fn fastcmp(arg1: pg.Datum, arg2: pg.Datum, _: pg.SortSupport) callconv(.C) i32 {
            const a = pg.datumGetValue(T, arg1);
            const b = pg.datumGetValue(T, arg2);

            return cmp(a, b);
        }
    };

    return func.fastcmp;
}

pub inline fn cmp(a: anytype, b: anytype) i32 {
    if (a > b)
        return 1;
    if (a == b)
        return 0;
    return -1;
}

pub inline fn btCmp(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.Int32GetDatum(cmp(a, b));
}

pub inline fn sortSupport(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const ssup = pg.getArgPointer(pg.SortSupport, fcinfo, 0);

    ssup.*.comparator = makeBTreeFastCMP(T);

    return pg.datumNull();
}

pub inline fn lt(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a < b);
}

pub inline fn le(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a <= b);
}

pub inline fn eq(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a == b);
}

pub inline fn ne(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a != b);
}

pub inline fn ge(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a >= b);
}

pub inline fn gt(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.BoolGetDatum(a > b);
}

pub inline fn add(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.getDatum(a + b);
}

pub inline fn sub(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.getDatum(a - b);
}

pub inline fn multiply(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.getDatum(a * b);
}

pub inline fn divide(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    if (b == 0) {
        pg.error_report(
            pg.ERROR,
            pg.ERRCODE_DIVISION_BY_ZERO,
            "division by zero",
        );

        return pg.datumNull();
    }

    return pg.getDatum(a / b);
}

pub inline fn mod(comptime Ta: type, comptime Tb: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(Ta, fcinfo, 0);
    const b = pg.getArgValue(Tb, fcinfo, 1);

    return pg.getDatum(a % b);
}
