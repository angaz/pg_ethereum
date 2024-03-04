const std = @import("std");
const pg = @import("./pg.zig");
const FixedBytes = @import("./fixed_bytes.zig").FixedBytes;

const array = FixedBytes(64);

pub export fn pg_finfo_array64in() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64in(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.in(fcinfo);
}

pub export fn pg_finfo_array64out() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64out(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.out(fcinfo);
}

pub export fn pg_finfo_array64receive() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.receive(fcinfo);
}

pub export fn pg_finfo_array64send() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64send(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.send(fcinfo);
}

pub export fn pg_finfo_btarray64cmp() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btarray64cmp(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.btreeCMP(fcinfo);
}

pub export fn pg_finfo_btarray64sortsupport() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn btarray64sortsupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.sortSupport(fcinfo);
}

pub export fn pg_finfo_array64hash() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64hash(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.hash(fcinfo);
}

pub export fn pg_finfo_array64lt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.lt(fcinfo);
}

pub export fn pg_finfo_array64le() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64le(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.le(fcinfo);
}

pub export fn pg_finfo_array64eq() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.eq(fcinfo);
}

pub export fn pg_finfo_array64ne() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.ne(fcinfo);
}

pub export fn pg_finfo_array64ge() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.ge(fcinfo);
}

pub export fn pg_finfo_array64gt() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.gt(fcinfo);
}

pub export fn pg_finfo_array64tobytea() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn array64tobytea(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.arrayToBytea(fcinfo);
}

pub export fn pg_finfo_byteatoarray64() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn byteatoarray64(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return array.byteaToArray(fcinfo);
}
