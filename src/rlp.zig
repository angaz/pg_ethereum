const std = @import("std");
const rlp = @import("zig-rlp");
const pg = @import("./pg.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn rlp_decode_generic(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const data = pg.getArgBytea(fcinfo, 0);
    var out: T = undefined;

    _ = rlp.deserialize(i64, allocator, data, &out) catch {
        pg.error_report(
            pg.ERROR,
            pg.ERRCODE_INVALID_BINARY_REPRESENTATION,
            "decode RLP failed",
        );

        return pg.datumNull();
    };

    return pg.getDatum(out);
}

pub export fn pg_finfo_rlp_decode_text() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn rlp_decode_text(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const data = pg.getArgBytea(fcinfo, 0);
    var out: []const u8 = undefined;

    _ = rlp.deserialize([]const u8, allocator, data, &out) catch {
        pg.error_report(
            pg.ERROR,
            pg.ERRCODE_INVALID_BINARY_REPRESENTATION,
            "decode RLP failed",
        );

        return pg.datumNull();
    };

    const result = pg.pallocArray(out.len + 1) orelse return pg.datumNull();

    std.mem.copyForwards(u8, result, out);
    result[out.len] = 0;

    return pg.CStringGetDatum(result.ptr);
}

pub export fn pg_finfo_rlp_decode_int64() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn rlp_decode_int64(fcinfo: pg.FunctionCallInfo) pg.Datum {
    return rlp_decode_generic(i64, fcinfo);
}
