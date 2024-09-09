const std = @import("std");
const stdout = @import("common.zig").stdout;
const stdout_flush = @import("common.zig").stdout_flush;
const executeCommands = @import("shell.zig").executeCommands;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const stdin_file = std.io.getStdIn().reader();

const Ansi = @import("common.zig").Ansi;

const stderr_file = std.io.getStdErr();
const stderr = stderr_file.writer();
const ArgIteratorGeneralOptions = std.process.ArgIteratorGeneralOptions;
const ArgIteratorGeneral = std.process.ArgIteratorGeneral;
const Parser = @import("Parser.zig");

/// TODO:
/// Look into argParser from std.process: https://github.com/ziglang/zig/blob/master/lib/std/process.zig
/// Tokenizes the input by using the read buffer to hold stdin. If the stdin input
/// exceeds the read buffer, there is an error.
pub fn main() !void {
    var buffer: [8192]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    var parser = try Parser.init(allocator);
    var read_buffer: [4096:0]u8 = undefined;
    var command_buffer: [32]?[*:0]u8 = [_]?[*:0]u8{null} ** 32;
    while (true) {
        // Print link for command
        try stdout.print("{s}→{s}  ", .{ Ansi.Cyan, Ansi.White });
        try stdout_flush();

        try parser.tokenizeInitialInput(&read_buffer);
        const command = if (parser.getCommand()) |cmd| cmd else continue;
        const args = parser.getArgs(&command_buffer);
        const status = executeCommands(command, args);
        switch (status.execution_status) {
            .Exit => {
                return;
            },
            .Success => {},
            .CommandNotFound => {
                try stderr.print("zshell: err: command not found\n", .{});
            },
            else => {
                if (status.display) {
                    try stdout.print("zshell: {s}\n", .{status.msg});
                }
            },
        }

        try stdout_flush();
        parser.free();
    }
}

//fn parseArgs() void {
//    const ArgParser = ArgIteratorGeneral(.{});
//    var arg_parser = ArgParser.init
//}
//

/// To split this up into a series of commands that can be changed into pipes
/// So for cat file.txt | head
///     ["cat", "file.txt", "|", "head"]
///     [["cat", "file.txt"], ["head"]]
fn split_pipe(token_buffer: [*:null]?[*:0]u8) [][*:null]?[*:0]u8 {
    // Iterate through token_buffer
    // If pipe character only, take indicate the slice, otherwise reutrn the total slice
    _ = token_buffer;
    return .{};
}
