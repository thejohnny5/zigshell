const std = @import("std");
const ExecutionInfo = @import("../common.zig").ExecutionInfo;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn chdir(args: [*:null]const ?[*:0]const u8) ExecutionInfo {
    const len = std.mem.len(args);
    if (len != @as(usize, 2)) {
        return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "cd expects exactly 1 argument", .display = true };
    }
    if (args[1]) |path| {
        const strlen = std.mem.len(path);
        const zstr = path[0..strlen];
        const dir = std.fs.cwd().openDir(zstr, .{}) catch return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "cd: directory does not exist", .display = true };
        dir.setAsCwd() catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "cd: could not set as currenty directory", .display = true };
        return ExecutionInfo{ .execution_status = .Success, .msg = "" };
    }
    return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "cd: null is not valid option", .display = true };
}
