const std = @import("std");
const pg = @import("./pg.zig");

pub export fn pg_finfo_uint4in() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint4in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const in: [*c]pg.text = pg.DatumGetTextPP(fcinfo.*.args()[0].value);

    const value = std.fmt.parseInt(u32, pg.span_text(in), 10) catch |err| {
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

        return pg.UInt32GetDatum(0);
    };

    return pg.UInt32GetDatum(value);
}

pub export fn pg_finfo_uint4out() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint4out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const in: u32 = pg.DatumGetUInt32(fcinfo.*.args()[0].value);
    const buf = pg.palloc(11) orelse unreachable;
    const result: []u8 = @as([*c]u8, @ptrCast(buf))[0..11];

    _ = std.fmt.formatIntBuf(result, in, 10, std.fmt.Case.lower, .{});

    return pg.CStringGetDatum(result.ptr);
}

pub export fn pg_info_uint4hash() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint4hash(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value: u32 = pg.DatumGetUInt32(fcinfo.*.args()[0].value);

    return pg.hash_uint32(value);
}
