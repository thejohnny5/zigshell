const std = @import("std");

pub const ExecutionInfo = struct {
    pub const ExecutionStatus = union(enum) { RuntimeError, ParsingError, Success, Exit, CommandNotFound, ArgumentError, CannotFork, ChildProcessError };
    execution_status: ExecutionStatus,
    msg: []const u8,
    display: bool = false,
};
const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
pub fn bw_write(bytes: []const u8) !usize {
    return try bw.write(bytes);
}
pub fn stdout_flush() !void {
    return try bw.flush();
}
pub const stdout = bw.writer();
