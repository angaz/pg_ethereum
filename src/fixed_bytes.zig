const std = @import("std");
const pg = @import("./pg.zig");

// `len` is size of the array in bytes
pub fn FixedBytes(comptime len: usize) type {
    return struct {
        pub inline fn in(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const inStr = pg.getArgCString(fcinfo, 0);

            if (inStr.len != len * 2) {
                pg.error_report(
                    pg.ERROR,
                    pg.ERRCODE_INVALID_TEXT_REPRESENTATION,
                    "incorrect length for fixed array type",
                );

                return pg.datumNull();
            }

            const arr = pg.pallocArray(len) orelse return pg.datumNull();

            _ = std.fmt.hexToBytes(arr, inStr) catch {
                pg.error_report(
                    pg.ERROR,
                    pg.ERRCODE_INVALID_TEXT_REPRESENTATION,
                    "invalid character",
                );

                return pg.datumNull();
            };

            return pg.PointerGetDatum(arr.ptr);
        }

        pub inline fn out(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const arr = pg.getArgSlice(len, fcinfo, 0);
            const result = pg.pallocArray(len * 2 + 1) orelse return pg.datumNull();

            const charset = "0123456789abcdef";
            for (arr, 0..) |b, i| {
                result[i * 2 + 0] = charset[b >> 4];
                result[i * 2 + 1] = charset[b & 15];
            }
            result[len * 2] = 0;

            return pg.CStringGetDatum(result.ptr);
        }

        pub inline fn receive(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const msg = pg.getArgPointer(pg.StringInfo, fcinfo, 0);
            const result = pg.pallocArray(len) orelse return pg.datumNull();

            pg.pq_copymsgbytes(msg, result.ptr, len);

            return pg.PointerGetDatum(result.ptr);
        }

        pub inline fn send(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const buf = pg.getArgPointer([*c]u8, fcinfo, 0);
            const msg: pg.StringInfo = undefined;

            pg.pq_begintypsend(msg);
            pg.pq_sendbytes(msg, buf, len);
            const bytea = pg.pq_endtypsend(msg);

            return pg.PointerGetDatum(bytea);
        }

        pub inline fn byteaToArray(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const bytea = pg.getArgPointer([*c]pg.bytea, fcinfo, 0);

            if (pg.varSize4B(bytea) != len + pg.VARHDRSZ) {
                pg.error_report(
                    pg.ERROR,
                    pg.ERRCODE_INVALID_TEXT_REPRESENTATION,
                    "incorrect length for fixed array type",
                );

                return pg.datumNull();
            }

            const data: []u8 = pg.varData4B(bytea)[0..len];
            const result = pg.pallocArray(len) orelse return pg.datumNull();

            @memcpy(result, data);

            return pg.PointerGetDatum(result.ptr);
        }

        pub inline fn arrayToBytea(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const array = pg.getArgSlice(len, fcinfo, 0);

            const result = pg.sliceToBytea(array) orelse return pg.datumNull();

            return pg.PointerGetDatum(result);
        }

        inline fn cmp(a: []u8, b: []u8) i32 {
            switch (std.mem.order(u8, a, b)) {
                .gt => return 1,
                .lt => return -1,
                .eq => return 0,
            }
        }

        fn btreeFastCMP(arg1: pg.Datum, arg2: pg.Datum, _: pg.SortSupport) callconv(.C) i32 {
            const a = pg.datumGetSlice(len, arg1);
            const b = pg.datumGetSlice(len, arg2);

            return cmp(a, b);
        }

        pub inline fn sortSupport(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const ssup = pg.getArgPointer(pg.SortSupport, fcinfo, 0);

            ssup.*.comparator = btreeFastCMP;

            return pg.datumNull();
        }

        pub inline fn btreeCMP(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.Int32GetDatum(cmp(a, b));
        }

        pub inline fn hash(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgPointer([*c]u8, fcinfo, 0);

            return pg.hash_any(a, len);
        }

        pub inline fn lt(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) == .lt);
        }

        pub inline fn le(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) != .gt);
        }

        pub inline fn eq(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) == .eq);
        }

        pub inline fn ne(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) != .eq);
        }

        pub inline fn gt(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) == .gt);
        }

        pub inline fn ge(fcinfo: pg.FunctionCallInfo) pg.Datum {
            const a = pg.getArgSlice(len, fcinfo, 0);
            const b = pg.getArgSlice(len, fcinfo, 1);

            return pg.BoolGetDatum(std.mem.order(u8, a, b) != .lt);
        }
    };
}
