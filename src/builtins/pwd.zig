const std = @import("std");
const ExecutionStatus = @import("../common.zig").ExecutionStatus;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn pwd(args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    _ = args;
    var buffer: [1024]u8 = undefined;
    const dir = std.fs.cwd().realpath(".", &buffer) catch return ExecutionStatus.RuntimeError;
    const size = stdout.write(dir) catch return ExecutionStatus.RuntimeError;
    const s2 = stdout.write("\n") catch return ExecutionStatus.RuntimeError;
    _ = size;
    _ = s2;

    stdout_flush() catch return ExecutionStatus.RuntimeError;
    return ExecutionStatus.Success;
}
