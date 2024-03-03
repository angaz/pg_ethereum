const std = @import("std");
const pg = @import("./pg.zig");
const uint = @import("./uint.zig");

pub export fn pg_finfo_uint8in() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.in(u64, fcinfo);
}

pub export fn pg_finfo_uint8out() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.out(u64, fcinfo);
}

pub export fn pg_finfo_uint8receive() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.receive(u64, fcinfo);
}

pub export fn pg_finfo_uint8send() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.send(u64, fcinfo);
}

pub export fn pg_finfo_btuint8uint8cmp() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btuint8uint8cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.btCmp(u64, u64, fcinfo);
}

pub export fn pg_finfo_btuint8sortsupport() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btuint8sortsupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.sortSupport(u64, fcinfo);
}

pub export fn pg_finfo_hashuint8() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn hashuint8(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value = pg.getArgValue(u64, fcinfo, 0);

    const lo: u32 = @truncate(value);
    const hi: u32 = @truncate(value >> 32);

    return pg.hash_uint32(lo ^ hi);
}

pub export fn pg_finfo_uint8uint8lt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.lt(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8le() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.le(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8eq() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.eq(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8ne() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.ne(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8ge() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.ge(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8gt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.gt(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8plus() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8add(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.add(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8minus() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8sub(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.sub(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8multiply() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8multiply(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.multiply(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8divide() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8divide(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.divide(u64, u64, fcinfo);
}

pub export fn pg_finfo_uint8uint8mod() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint8uint8mod(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.mod(u64, u64, fcinfo);
}
