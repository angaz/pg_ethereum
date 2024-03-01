// Magic PostgreSQL symbols to indicate it's a loadable module
pub const PG_MAGIC_FUNCTION_NAME = Pg_magic_func;
pub const PG_MAGIC_FUNCTION_NAME_STRING = "Pg_magic_func";

pub const PGModuleMagicFunction = ?*const fn () callconv(.C) [*c]const Pg_magic_struct;
pub const Pg_magic_struct = extern struct {
    len: c_int,
    version: c_int,
    funcmaxargs: c_int,
    indexmaxkeys: c_int,
    namedatalen: c_int,
    float8byval: c_int,
    abi_extra: [32]u8,
};

pub export fn Pg_magic_func() [*c]const Pg_magic_struct {
    const Pg_magic_data = struct {
        const static: Pg_magic_struct = Pg_magic_struct{
            .len = @bitCast(@as(c_uint, @truncate(@sizeOf(Pg_magic_struct)))),
            .version = @divTrunc(@as(c_int, 160000), @as(c_int, 100)),
            .funcmaxargs = @as(c_int, 100),
            .indexmaxkeys = @as(c_int, 32),
            .namedatalen = @as(c_int, 64),
            .float8byval = @as(c_int, 1),
            .abi_extra = [32]u8{ 'P', 'o', 's', 't', 'g', 'r', 'e', 'S', 'Q', 'L', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        };
    };
    return &Pg_magic_data.static;
}
// end of magic PostgreSQL symbols
