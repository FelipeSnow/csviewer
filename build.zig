const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = std.zig.CrossTarget{ .os_tag = .windows, .cpu_arch = .x86_64 };

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
    });

    b.installArtifact(exe);
}
