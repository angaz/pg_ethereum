const std = @import("std");
const rlp = @import("zig-rlp");
const pg = @import("./pg.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub export fn pg_finfo_rlp_decode_record() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn rlp_decode_record(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const data = pg.getArgBytea(fcinfo, 0);
    var tuple_desc: pg.TupleDesc = undefined;
    const func_type_class = pg.get_call_result_type(fcinfo, null, &tuple_desc);
    const nAttributes: usize = @intCast(tuple_desc.*.natts);
    const attrs = tuple_desc.*.attrs()[0..nAttributes];

    var readOffset: usize = 0;

    const values = pg.pallocArrayOf(pg.Datum, nAttributes) orelse return pg.datumNull();
    const nulls = pg.pallocArrayOf(bool, nAttributes) orelse return pg.datumNull();

    for (attrs, 0..) |attr, idx| {
        std.debug.print(
            "{}: {s}, {}\n",
            .{
                idx,
                attr.attname.data,
                attr.atttypid,
            },
        );

        switch (attr.atttypid) {
            pg.INT8OID => {
                var decoded: i64 = 0;

                readOffset += rlp.deserialize(i64, allocator, data[readOffset..], &decoded) catch {
                    pg.error_report(
                        pg.ERROR,
                        pg.ERRCODE_INVALID_BINARY_REPRESENTATION,
                        "decode RLP failed",
                    );

                    return pg.datumNull();
                };

                values[idx] = pg.getDatum(decoded);
                nulls[idx] = false;
            },
            pg.TEXTOID => {
                var decoded: []const u8 = undefined;

                readOffset += rlp.deserialize([]const u8, allocator, data[readOffset..], &decoded) catch {
                    pg.error_report(
                        pg.ERROR,
                        pg.ERRCODE_INVALID_BINARY_REPRESENTATION,
                        "decode RLP failed",
                    );

                    return pg.datumNull();
                };

                const result = pg.sliceToBytea(decoded) orelse return pg.datumNull();

                values[idx] = pg.PointerGetDatum(result);
                nulls[idx] = false;
            },
            else => {
                std.debug.print(
                    "unsupported type: {d}: {d}\n",
                    .{
                        idx,
                        attr.atttypid,
                    },
                );

                unreachable;
            },
        }
    }

    if (func_type_class != pg.TYPEFUNC_COMPOSITE) {
        pg.error_report(
            pg.ERROR,
            pg.ERRCODE_FDW_INVALID_DATA_TYPE_DESCRIPTORS,
            "func type class is not composite",
        );

        return pg.datumNull();
    }

    const tuple = pg.heap_form_tuple(tuple_desc, values, nulls);

    return pg.HeapTupleGetDatum(tuple);
}

fn rlp_decode_generic(comptime T: type, fcinfo: pg.FunctionCallInfo) pg.Datum {
    const data = pg.getArgBytea(fcinfo, 0);
    var out: T = undefined;

    _ = rlp.deserialize(T, allocator, data, &out) catch {
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
