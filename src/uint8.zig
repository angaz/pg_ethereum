const std = @import("std");
const pg = @import("./pg.zig");
const uint = @import("./uint.zig");

pub export fn pg_finfo_uint8in() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.in(u64, fcinfo);
}

pub export fn pg_finfo_uint8out() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.out(u64, fcinfo);
}

pub export fn pg_finfo_uint8receive() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.receive(u64, fcinfo);
}

pub export fn pg_finfo_uint8send() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(u64, fcinfo, 0);
    const msg: pg.StringInfo = undefined;

    pg.pq_begintypsend(msg);
    pg.pq_sendint64(msg, value);
    const bytea = pg.pq_endtypsend(msg);

    return pg.PointerGetDatum(bytea);
}

pub export fn pg_finfo_btuint8uint8cmp() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn btuint8uint8cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const arg1 = pg.getArgValue(u64, fcinfo, 0);
    const arg2 = pg.getArgValue(u64, fcinfo, 1);

    return pg.Int32GetDatum(uint.cmp(arg1, arg2));
}

fn btuint8fastcmp(arg1: pg.Datum, arg2: pg.Datum, _: pg.SortSupport) callconv(.C) i32 {
    const a = pg.DatumGetUInt64(arg1);
    const b = pg.DatumGetUInt64(arg2);

    return uint.cmp(a, b);
}

pub export fn pg_finfo_btuint8sortsupport() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn btuint8sortsupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const ssup = pg.getArgPointer(pg.SortSupport, fcinfo, 0);

    ssup.*.comparator = btuint8fastcmp;

    return pg.datumNull();
}

pub export fn pg_finfo_hashuint8() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn hashuint8(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(u64, fcinfo, 0);

    const lo: u32 = @truncate(value);
    const hi: u32 = @truncate(value >> 32);

    return pg.hash_uint32(lo ^ hi);
}

pub export fn pg_finfo_uint8uint8lt() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a < b);
}

pub export fn pg_finfo_uint8uint8le() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a <= b);
}

pub export fn pg_finfo_uint8uint8eq() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a == b);
}

pub export fn pg_finfo_uint8uint8ne() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a != b);
}

pub export fn pg_finfo_uint8uint8ge() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a >= b);
}

pub export fn pg_finfo_uint8uint8gt() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.BoolGetDatum(a > b);
}

pub export fn pg_finfo_uint8uint8plus() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8plus(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.UInt64GetDatum(a + b);
}

pub export fn pg_finfo_uint8uint8minus() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8minus(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.UInt64GetDatum(a - b);
}

pub export fn pg_finfo_uint8uint8multiply() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8multiply(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.UInt64GetDatum(a * b);
}

pub export fn pg_finfo_uint8uint8divide() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8divide(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    if (b == 0) {
        pg.error_report(
            pg.ERROR,
            pg.ERRCODE_DIVISION_BY_ZERO,
            "division by zero",
        );

        return pg.datumNull();
    }

    return pg.UInt64GetDatum(a / b);
}

pub export fn pg_finfo_uint8uint8mod() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8mod(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgValue(u64, fcinfo, 0);
    const b = pg.getArgValue(u64, fcinfo, 1);

    return pg.UInt64GetDatum(a % b);
}
