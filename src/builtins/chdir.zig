const std = @import("std");
const ExecutionInfo = @import("../common.zig").ExecutionInfo;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn chdir(args: []?[*:0]const u8) ExecutionInfo {
    if (args.len < 2) {
        return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "cd expects exactly 1 argument", .display = true };
    }
    const path = args[1] orelse return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "Wrong path input", .display = true };
    const strlen = std.mem.len(path);
    const zstr = path[0..strlen];
    const dir = std.fs.cwd().openDir(zstr, .{}) catch return ExecutionInfo{ .execution_status = .ArgumentError, .msg = "cd: directory does not exist", .display = true };
    dir.setAsCwd() catch return ExecutionInfo{ .execution_status = .RuntimeError, .msg = "cd: could not set as currenty directory", .display = true };
    return ExecutionInfo{ .execution_status = .Success, .msg = "" };
}
