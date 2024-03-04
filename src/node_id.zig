const std = @import("std");
const pg = @import("./pg.zig");

pub export fn pg_finfo_pubkey_to_node_id() pg.FinfoRecord {
    return pg.function_info_v1();
}

pub export fn pubkey_to_node_id(fcinfo: pg.FunctionCallInfo) pg.Datum {
    const pubkey = pg.getArgSlice(64, fcinfo, 0);

    var nodeID = [_]u8{0} ** 32;
    std.crypto.hash.sha3.Keccak256.hash(pubkey, &nodeID, .{});

    const arr = pg.pallocArray(32) orelse return pg.datumNull();
    @memcpy(arr, nodeID[0..32]);

    return pg.PointerGetDatum(arr.ptr);
}
