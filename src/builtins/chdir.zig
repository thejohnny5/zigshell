const std = @import("std");
const ExecutionStatus = @import("../common.zig").ExecutionStatus;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn chdir(args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    const len = std.mem.len(args);
    if (len != @as(usize, 2)) {
        return ExecutionStatus.RuntimeError;
    }
    if (args[1]) |path| {
        const strlen = std.mem.len(path);
        const zstr = path[0..strlen];
        const dir = std.fs.cwd().openDir(zstr, .{}) catch return ExecutionStatus.RuntimeError;
        dir.setAsCwd() catch return ExecutionStatus.RuntimeError;
        return ExecutionStatus.Success;
    }
    return ExecutionStatus.RuntimeError;
}
