const std = @import("std");

// CONTROL CHARACTERS
pub const Ansi = struct {
    // Control Characters
    pub const Reset = "\x1b[0m";
    pub const Bold = "\x1b[1m";
    pub const Faint = "\x1b[2m";
    pub const Italic = "\x1b[3m";
    pub const Underline = "\x1b[4m";
    pub const BlinkSlow = "\x1b[5m";
    pub const BlinkRapid = "\x1b[6m";
    pub const Reverse = "\x1b[7m";
    pub const Conceal = "\x1b[8m";
    pub const CrossedOut = "\x1b[9m";

    // Text Colors
    pub const Black = "\x1b[30m";
    pub const Red = "\x1b[31m";
    pub const Green = "\x1b[32m";
    pub const Yellow = "\x1b[33m";
    pub const Blue = "\x1b[34m";
    pub const Magenta = "\x1b[35m";
    pub const Cyan = "\x1b[36m";
    pub const White = "\x1b[37m";
    pub const DefaultTextColor = "\x1b[39m";

    // Background Colors
    pub const BgBlack = "\x1b[40m";
    pub const BgRed = "\x1b[41m";
    pub const BgGreen = "\x1b[42m";
    pub const BgYellow = "\x1b[43m";
    pub const BgBlue = "\x1b[44m";
    pub const BgMagenta = "\x1b[45m";
    pub const BgCyan = "\x1b[46m";
    pub const BgWhite = "\x1b[47m";
    pub const DefaultBackgroundColor = "\x1b[49m";

    // Bright Text Colors (High Intensity)
    pub const BrightBlack = "\x1b[90m";
    pub const BrightRed = "\x1b[91m";
    pub const BrightGreen = "\x1b[92m";
    pub const BrightYellow = "\x1b[93m";
    pub const BrightBlue = "\x1b[94m";
    pub const BrightMagenta = "\x1b[95m";
    pub const BrightCyan = "\x1b[96m";
    pub const BrightWhite = "\x1b[97m";

    // Bright Background Colors (High Intensity)
    pub const BgBrightBlack = "\x1b[100m";
    pub const BgBrightRed = "\x1b[101m";
    pub const BgBrightGreen = "\x1b[102m";
    pub const BgBrightYellow = "\x1b[103m";
    pub const BgBrightBlue = "\x1b[104m";
    pub const BgBrightMagenta = "\x1b[105m";
    pub const BgBrightCyan = "\x1b[106m";
    pub const BgBrightWhite = "\x1b[107m";

    // Erasing Text
    pub const EraseToEndOfLine = "\x1b[K";
    pub const EraseToBeginningOfLine = "\x1b[1K";
    pub const EraseEntireLine = "\x1b[2K";
    pub const EraseToEndOfScreen = "\x1b[J";
    pub const EraseToBeginningOfScreen = "\x1b[1J";
    pub const EraseEntireScreen = "\x1b[2J";

    // Cursor Controls
    pub fn moveCursorUp(n: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{}A", .{n});
    }

    pub fn moveCursorDown(n: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{}B", .{n});
    }

    pub fn moveCursorForward(n: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{}C", .{n});
    }

    pub fn moveCursorBackward(n: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{}D", .{n});
    }

    pub fn moveCursorToColumn(n: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{}G", .{n});
    }

    pub fn moveCursorToPosition(y: u8, x: u8) ![]const u8 {
        return try std.fmt.allocPrint(std.heap.page_allocator, "\x1b[{};{}H", .{ y, x });
    }

    // Example Usage Function
    pub fn exampleUsage() void {
        _ = stdout.print("{}Hello, World!{}\n", .{ Ansi.Red, Ansi.Reset });
    }
};

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
