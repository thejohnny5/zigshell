const std = @import("std");
const stdout = @import("common.zig").stdout;
const stdout_flush = @import("common.zig").stdout_flush;
const execute_commands = @import("shell.zig").execute_commands;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const stdin_file = std.io.getStdIn().reader();
var br = std.io.bufferedReader(stdin_file);
var stdin = br.reader();

/// Tokenizes the input by using the read buffer to hold stdin. If the stdin input
/// exceeds the read buffer, there is an error.
fn tokenizeInitialInput(read_buffer: [:0]u8, token_buffer: []?[*:0]u8) ![]?[*:0]u8 {
    var current: usize = 0;
    while (try stdin.readUntilDelimiterOrEof(read_buffer, '\n')) |line| {
        if (line.len == read_buffer.len) {
            // should error
        }

        var start: usize = 0;
        for (line, 0..) |char, index| {
            if (char == ' ' and index - start > 0) {
                read_buffer[index] = 0;
                const curr_line: [:0]u8 = line[start..index :0];
                token_buffer[current] = curr_line.ptr;
                start = index + 1;
                current += 1;
            }
        } else {
            if (start < line.len and line[start] != ' ') {
                read_buffer[line.len] = 0;
                const curr_line: [:0]u8 = read_buffer[start..line.len :0];
                token_buffer[current] = curr_line.ptr;
                start = line.len;
                current += 1;
            }
        }
        break;
    }
    token_buffer[current] = null;
    return token_buffer[0 .. current + 1];
}

pub fn main() !void {
    while (true) {
        // Print link for command
        try stdout.print("→  ", .{});
        try stdout_flush();
        var read_buffer: [4096:0]u8 = undefined;
        var token_buffer: [40]?[*:0]u8 = undefined;
        const tokens = try tokenizeInitialInput(&read_buffer, &token_buffer);
        const args: [*:null]?[*:0]u8 = tokens[0 .. tokens.len - 1 :null].ptr;
        const command = tokens[0];
        if (command) |cmd| {
            const status = execute_commands(cmd, args);
            std.debug.print("Execution Status: {}\n", .{status});
            switch (status) {
                ExecutionStatus.Exit => {
                    return;
                },
                ExecutionStatus.Success => {
                    //try stdout.print("\n", .{});
                },
                ExecutionStatus.CommandNotFound => {
                    try stdout.print("Err: Command Not Found\n", .{});
                },
                else => {},
            }
        } else {
            continue;
        }
        try stdout_flush();
    }
}
