const std = @import("std");
const pgzx = @import("pgzx");
const pg = @import("./pg.zig");

const pkg = @This();

pub fn Uint(comptime T: type) type {
    return struct {
        pub fn in(comptime base: u8) fn ([:0]const u8) error{PGErrorStack}!T {
            return struct {
                fn in(str: [:0]const u8) !T {
                    return std.fmt.parseInt(T, str, base) catch |err| {
                        switch (err) {
                            error.Overflow => return pgzx.elog.Error(@src(), "value \"{s}\" is out of range for type integer", .{str}),
                            error.InvalidCharacter => return pgzx.elog.Error(@src(), "invalid input syntax for type integer: \"{s}\"", .{str}),
                        }
                    };
                }
            }.in;
        }

        pub fn out(comptime base: u8) fn (T) error{ PGErrorStack, OutOfMemory }![:0]u8 {
            return struct {
                fn out(value: T) error{ PGErrorStack, OutOfMemory }![:0]u8 {
                    const outLen: usize = switch (base) {
                        10 => switch (@as(u64, value)) {
                            0...9999 => 4,
                            10000...99999999 => 8,
                            100000000...999999999999 => 12,
                            1000000000000...9999999999999999 => 16,
                            else => 20,
                        },
                        16 => @sizeOf(T) * 2,
                        else => @compileError("Unsupported base"),
                    };

                    var result = try pgzx.mem.PGCurrentContextAllocator.alloc(u8, outLen + 1);

                    const pos = std.fmt.formatIntBuf(result, value, base, std.fmt.Case.lower, .{});
                    @memset(result[pos..], 0);

                    return result[0..pos :0];
                }
            }.out;
        }

        pub fn receive(msg: pgzx.c.StringInfo) !T {
            return switch (T) {
                u64 => @bitCast(pgzx.c.pq_getmsgint64(msg)),
                u32 => pgzx.c.pq_getmsgint(msg, 4),
                else => @compileError("Unsupported type"),
            };
        }

        pub fn send(value: T) !pgzx.c.Datum {
            const msg: pgzx.c.StringInfo = undefined;

            pgzx.c.pq_begintypsend(msg);

            switch (T) {
                u64 => pgzx.c.pq_sendint64(msg, value),
                u32 => pgzx.c.pq_sendint32(msg, value),
                else => @compileError("Unsupported type"),
            }

            const bytea = pgzx.c.pq_endtypsend(msg);

            return pgzx.c.PointerGetDatum(bytea);
        }

        fn fastcmp(arg1: pgzx.c.Datum, arg2: pgzx.c.Datum, _: pgzx.c.SortSupport) callconv(.C) i32 {
            const a = pg.datumGetValue(T, arg1);
            const b = pg.datumGetValue(T, arg2);

            return cmp(a, b);
        }

        pub fn sortSupport(ssup: pgzx.c.SortSupport) !void {
            ssup.*.comparator = fastcmp;
        }

        pub fn btCmp(a: T, b: T) !i32 {
            return pkg.btCmp(T, T)(a, b);
        }

        pub fn lt(a: T, b: T) !bool {
            return pkg.lt(T, T)(a, b);
        }

        pub fn le(a: T, b: T) !bool {
            return pkg.le(T, T)(a, b);
        }

        pub fn eq(a: T, b: T) !bool {
            return pkg.eq(T, T)(a, b);
        }

        pub fn ne(a: T, b: T) !bool {
            return pkg.ne(T, T)(a, b);
        }

        pub fn ge(a: T, b: T) !bool {
            return pkg.ge(T, T)(a, b);
        }

        pub fn gt(a: T, b: T) !bool {
            return pkg.gt(T, T)(a, b);
        }

        pub fn add(a: T, b: T) !T {
            return pkg.add(T, T)(a, b);
        }

        pub fn sub(a: T, b: T) !T {
            return pkg.sub(T, T)(a, b);
        }

        pub fn multiply(a: T, b: T) !T {
            return pkg.multiply(T, T)(a, b);
        }

        pub fn divide(a: T, b: T) !T {
            return pkg.divide(T, T)(a, b);
        }

        pub fn mod(a: T, b: T) !T {
            return pkg.mod(T, T)(a, b);
        }
    };
}

pub inline fn cmp(a: anytype, b: anytype) i32 {
    if (a > b)
        return 1;
    if (a == b)
        return 0;
    return -1;
}

pub fn btCmp(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) i32 {
    return struct {
        fn btCmp(a: Ta, b: Tb) i32 {
            return cmp(a, b);
        }
    }.btCmp;
}

pub fn lt(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn lt(a: Ta, b: Tb) bool {
            return a < b;
        }
    }.lt;
}

pub fn le(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn le(a: Ta, b: Tb) bool {
            return a <= b;
        }
    }.le;
}

pub fn eq(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn eq(a: Ta, b: Tb) bool {
            return a == b;
        }
    }.eq;
}

pub fn ne(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn ne(a: Ta, b: Tb) bool {
            return a != b;
        }
    }.ne;
}

pub fn ge(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn ge(a: Ta, b: Tb) bool {
            return a >= b;
        }
    }.ge;
}

pub fn gt(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) bool {
    return struct {
        fn gt(a: Ta, b: Tb) bool {
            return a > b;
        }
    }.gt;
}

pub fn add(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) Ta {
    return struct {
        fn add(a: Ta, b: Tb) Ta {
            return a + b;
        }
    }.add;
}

pub fn sub(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) Ta {
    return struct {
        fn sub(a: Ta, b: Tb) Ta {
            return a - b;
        }
    }.sub;
}

pub fn multiply(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) Ta {
    return struct {
        fn multiply(a: Ta, b: Tb) Ta {
            return a * b;
        }
    }.multiply;
}

pub fn divide(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) error{PGErrorStack}!Ta {
    return struct {
        fn divide(a: Ta, b: Tb) error{PGErrorStack}!Ta {
            if (b == 0) {
                return pgzx.elog.Error(@src(), "divide by zero", .{});
            }

            return a / b;
        }
    }.divide;
}

pub fn mod(comptime Ta: type, comptime Tb: type) fn (Ta, Tb) Ta {
    return struct {
        fn mod(a: Ta, b: Tb) Ta {
            return a % b;
        }
    }.mod;
}
