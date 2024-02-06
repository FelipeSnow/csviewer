const std = @import("std");
const fs = std.fs;
const os = std.os;

fn parseFilePathArg(args: [][:0]u8) ![]u8 {
    std.debug.print("There are {d} args:\n", .{args.len});
    var filePath: []u8 = args[1];

    return filePath;
}

pub fn main() !void {
    var gp = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gp.allocator();
    defer _ = gp.deinit();

    const args = try std.process.argsAlloc(alloc);
    defer std.process.argsFree(alloc, args);

    if (args.len < 2) {
        std.debug.print("Provide an file path", .{});
        return;
    }

    var cwd_buf: [fs.MAX_PATH_BYTES]u8 = undefined;

    const cwd_path = try os.getcwd(&cwd_buf);
    const cwd = try fs.openDirAbsolute(cwd_path, .{});

    var file = try fs.Dir.openFile(cwd, args[1], .{ .mode = std.fs.File.OpenMode.read_only });
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: []u8 = undefined;

    while (try in_stream.readAtLeast(&buf, 2040)) |line| {
        std.debug.print("{s}\n", .{line});
    }
}
