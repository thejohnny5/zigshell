const std = @import("std");
const ExecutionInfo = @import("../common.zig").ExecutionInfo;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn pwd(args: []?[*:0]const u8) ExecutionInfo {
    _ = args;
    var buffer: [1024]u8 = undefined;
    const dir = std.fs.cwd().realpath(".", &buffer) catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "pwd: could not get path", .display = true };
    const size = stdout.write(dir) catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "pwd: could not write", .display = true };
    const s2 = stdout.write("\n") catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "pwd: could not write", .display = true };
    _ = size;
    _ = s2;

    stdout_flush() catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "pwd: could not flush", .display = true };
    return ExecutionInfo{ .execution_status = .Success, .msg = "" };
}
