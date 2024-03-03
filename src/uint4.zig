const std = @import("std");
const pg = @import("./pg.zig");
const uint = @import("./uint.zig");

pub export fn pg_finfo_uint4in() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.in(u32, 10, fcinfo);
}

pub export fn pg_finfo_uint4inhex() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4inhex(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.in(u32, 16, fcinfo);
}

pub export fn pg_finfo_uint4out() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.out(u32, 10, fcinfo);
}

pub export fn pg_finfo_uint4outhex() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4outhex(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.out(u32, 16, fcinfo);
}

pub export fn pg_finfo_uint4hash() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4hash(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const value: u32 = pg.DatumGetUInt32(fcinfo.*.args()[0].value);

    return pg.hash_uint32(value);
}

pub export fn pg_finfo_uint4receive() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.receive(u32, fcinfo);
}

pub export fn pg_finfo_uint4send() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.send(u32, fcinfo);
}

pub export fn pg_finfo_btuint4uint4cmp() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btuint4uint4cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.btCmp(u32, u32, fcinfo);
}

pub export fn pg_finfo_btuint4sortsupport() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btuint4sortsupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.sortSupport(u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4lt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.lt(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4le() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.le(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4eq() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.eq(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4ne() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.ne(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4ge() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.ge(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4gt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.gt(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4add() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4add(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.add(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4sub() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4sub(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.sub(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4multiply() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4multiply(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.multiply(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4divide() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4divide(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.divide(u32, u32, fcinfo);
}

pub export fn pg_finfo_uint4uint4mod() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn uint4uint4mod(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return uint.mod(u32, u32, fcinfo);
}
