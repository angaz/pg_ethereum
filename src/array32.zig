const std = @import("std");
const pg = @import("./pg.zig");
const FixedBytes = @import("./fixed_bytes.zig").FixedBytes;

const array = FixedBytes(32);

pub export fn pg_finfo_array32in() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.in(fcinfo);
}

pub export fn pg_finfo_array32out() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.out(fcinfo);
}

pub export fn pg_finfo_array32receive() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.receive(fcinfo);
}

pub export fn pg_finfo_array32send() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.send(fcinfo);
}

pub export fn pg_finfo_btarray32cmp() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btarray32cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.btreeCMP(fcinfo);
}

pub export fn pg_finfo_btarray32sortsupport() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btarray32sortsupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.sortSupport(fcinfo);
}

pub export fn pg_finfo_array32hash() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32hash(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.hash(fcinfo);
}

pub export fn pg_finfo_array32lt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.lt(fcinfo);
}

pub export fn pg_finfo_array32le() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.le(fcinfo);
}

pub export fn pg_finfo_array32eq() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.eq(fcinfo);
}

pub export fn pg_finfo_array32ne() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.ne(fcinfo);
}

pub export fn pg_finfo_array32ge() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.ge(fcinfo);
}

pub export fn pg_finfo_array32gt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.gt(fcinfo);
}

pub export fn pg_finfo_array32tobytea() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array32tobytea(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.arrayToBytea(fcinfo);
}

pub export fn pg_finfo_byteatoarray32() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn byteatoarray32(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.byteaToArray(fcinfo);
}
