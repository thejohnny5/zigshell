const std = @import("std");
pub const ExecutionStatus = union(enum) { RuntimeError, ParsingError, Success, Exit, CommandNotFound, ArgumentError };

const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
pub fn bw_write(bytes: []const u8) !usize {
    return try bw.write(bytes);
}
pub fn stdout_flush() !void {
    return try bw.flush();
}
pub const stdout = bw.writer();
