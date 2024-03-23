const std = @import("std");

// Load pgzx build support. The build utilities use pg_config to find all dependencies
// and provide functions go create and test extensions.
const PGBuild = @import("pgzx").Build;

pub fn build(b: *std.Build) void {
    const name = "pg_ethereum";
    const version = .{ .major = 0, .minor = 1 };

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var pgbuild = PGBuild.create(b, .{
        .target = target,
        .optimize = optimize,
    });

    // Register the dependency with the build system
    // and add pgzx as module dependency.
    const ext = pgbuild.addInstallExtension(.{
        .name = name,
        .version = version,
        .root_source_file = .{ .path = "src/root.zig" },
        .root_dir = ".",
    });
    ext.lib.root_module.addOptions("build_options", b.addOptions());

    ext.lib.root_module.addImport(
        "pgzx",
        b.dependency("pgzx", .{
            .target = target,
            .optimize = optimize,
        }).module("pgzx"),
    );
    ext.lib.root_module.addImport(
        "zig-rlp",
        b.dependency("zig-rlp", .{
            .target = target,
            .optimize = optimize,
        }).module("rlp"),
    );

    b.getInstallStep().dependOn(&ext.step);
}
