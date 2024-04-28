const std = @import("std");
const ExecutionStatus = @import("../common.zig").ExecutionStatus;
const stdout = @import("../common.zig").stdout;
const stdout_flush = @import("../common.zig").stdout_flush;
const stdout_write = @import("../common.zig").bw_write;
pub fn chdir(args: ?[][]u8) ExecutionStatus {
    if (args) |arg_array| {
        std.debug.print("Args: {s}, len: {d}\n", .{ arg_array[0], arg_array[0].len });
        const dir = std.fs.cwd().openDir(arg_array[0], .{}) catch |err| {
            std.debug.print("Error: {any}\n", .{err});
            return ExecutionStatus.RuntimeError;
        };
        std.debug.print("Arg: {any}\n", .{arg_array[0]});
        std.debug.print("Dir struct: {any}\n", .{dir});
        dir.setAsCwd() catch return ExecutionStatus.RuntimeError;
        return ExecutionStatus.Success;
    }
    return ExecutionStatus.RuntimeError;
}
