const std = @import("std");
const testing = std.testing;
const pg = @import("./pg.zig");

pub usingnamespace @import("./pg_magic.zig");

pub export fn uint8in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const in: [*c]pg.text = pg.DatumGetTextPP(fcinfo.*.args()[0].value);

    const value = std.fmt.parseInt(u64, pg.span_text(in), 10) catch |err| {
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

        return pg.UInt64GetDatum(0);
    };

    return pg.UInt64GetDatum(value);
}

// Basically PG_FUNCTION_INFO_V1
pub export fn pg_finfo_uint8in() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const in: u64 = pg.DatumGetUInt64(fcinfo.*.args()[0].value);
    const buf = pg.palloc(21) orelse unreachable;
    const result: []u8 = @as([*c]u8, @ptrCast(buf))[0..21];

    _ = std.fmt.formatIntBuf(result, in, 10, std.fmt.Case.lower, .{});

    return pg.CStringGetDatum(result.ptr);
}

// Basically PG_FUNCTION_INFO_V1
pub export fn pg_finfo_uint8out() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}
