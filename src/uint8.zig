const std = @import("std");
const pg = @import("./pg.zig");

pub export fn pg_finfo_uint8in() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const inStr = pg.getArgCString(fcinfo, 0);
    std.debug.print("in str: {s}\n", .{inStr});

    const value = std.fmt.parseInt(u64, inStr, 10) catch |err| {
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

pub export fn pg_finfo_uint8out() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const in: u64 = pg.DatumGetUInt64(fcinfo.*.args()[0].value);
    const buf = pg.palloc(21) orelse unreachable;
    const result: []u8 = @as([*c]u8, @ptrCast(buf))[0..21];

    _ = std.fmt.formatIntBuf(result, in, 10, std.fmt.Case.lower, .{});

    return pg.CStringGetDatum(result.ptr);
}

pub export fn pg_finfo_uint8recieve() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

// Datum
// uuid_recv(PG_FUNCTION_ARGS)
// {
// 	StringInfo	buffer = (StringInfo) PG_GETARG_POINTER(0);
// 	pg_uuid_t  *uuid;

// 	uuid = (pg_uuid_t *) palloc(UUID_LEN);
// 	memcpy(uuid->data, pq_getmsgbytes(buffer, UUID_LEN), UUID_LEN);
// 	PG_RETURN_POINTER(uuid);
// }
pub export fn uint8recieve(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const msg = pg.getArgPointer(pg.StringInfo, fcinfo, 0);

    const value = pg.pq_getmsgint64(msg);

    return pg.UInt64GetDatum(value);
}

// Datum
// uuid_send(PG_FUNCTION_ARGS)
// {
// 	pg_uuid_t  *uuid = PG_GETARG_UUID_P(0);
// 	StringInfoData buffer;

// 	pq_begintypsend(&buffer);
// 	pq_sendbytes(&buffer, uuid->data, UUID_LEN);
// 	PG_RETURN_BYTEA_P(pq_endtypsend(&buffer));
// }
pub export fn uint8send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgUInt64(fcinfo, 0);
    var msg = pg.makeStringInfo();

    pg.pq_begintypsend(&msg);
    pg.pq_sendint64(&msg, value);
    const bytea = pg.pq_endtypsend(&msg);

    return pg.PointerGetDatum(bytea);
}

inline fn intCmp(a: anytype, b: anytype) i32 {
    if (a > b)
        return 1;
    if (a == b)
        return 0;
    return -1;
}

pub export fn pg_finfo_btuint8uint8cmp() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn btuint8uint8cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const arg1 = pg.getArgUInt64(fcinfo, 0);
    const arg2 = pg.getArgUInt64(fcinfo, 1);

    return pg.Int32GetDatum(intCmp(arg1, arg2));
}

fn btuint8fastcmp(arg1: pg.Datum, arg2: pg.Datum, _: pg.SortSupport) callconv(.C) i32 {
    const a = pg.DatumGetUInt64(arg1);
    const b = pg.DatumGetUInt64(arg2);

    return intCmp(a, b);
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
    const value = pg.getArgUInt64(fcinfo, 0);

    const lo: u32 = @truncate(value);
    const hi: u32 = @truncate(value >> 32);

    return pg.hash_uint32(lo ^ hi);
}

pub export fn pg_finfo_uint8uint8lt() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a < b);
}

pub export fn pg_finfo_uint8uint8le() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a <= b);
}

pub export fn pg_finfo_uint8uint8eq() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a == b);
}

pub export fn pg_finfo_uint8uint8ne() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a != b);
}

pub export fn pg_finfo_uint8uint8ge() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a >= b);
}

pub export fn pg_finfo_uint8uint8gt() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.BoolGetDatum(a > b);
}

pub export fn pg_finfo_uint8uint8plus() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8plus(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.UInt64GetDatum(a + b);
}

pub export fn pg_finfo_uint8uint8minus() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8minus(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.UInt64GetDatum(a - b);
}

pub export fn pg_finfo_uint8uint8multiply() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8multiply(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.UInt64GetDatum(a * b);
}

pub export fn pg_finfo_uint8uint8divide() [*c]const pg.Pg_finfo_record {
    return pg.function_info_v1();
}

pub export fn uint8uint8divide(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

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
    const a = pg.getArgUInt64(fcinfo, 0);
    const b = pg.getArgUInt64(fcinfo, 1);

    return pg.UInt64GetDatum(a % b);
}
