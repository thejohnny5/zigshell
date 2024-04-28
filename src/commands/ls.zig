const std = @import("std");
const ExecutionStatus = @import("../common.zig").ExecutionStatus;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn ls(args: [][]u8) ExecutionStatus {
    _ = args;
    const dir = std.fs.cwd().openDir("./", .{ .iterate = true }) catch return ExecutionStatus.ArgumentError;

    var it = dir.iterate();
    while (it.next() catch return ExecutionStatus.RuntimeError) |file| {
        const size = stdout_write(file.name) catch return ExecutionStatus.RuntimeError;
        _ = size;
        const size2 = stdout_write(&[2]u8{ ' ', ' ' }) catch return ExecutionStatus.RuntimeError;
        _ = size2;
    }
    stdout_flush() catch return ExecutionStatus.RuntimeError;
    return ExecutionStatus.Success;
}
