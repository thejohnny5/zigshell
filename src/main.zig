const std = @import("std");
const stdout = @import("common.zig").stdout;
const stdout_flush = @import("common.zig").stdout_flush;
const execute_commands = @import("shell.zig").execute_commands;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const stdin_file = std.io.getStdIn().reader();
var br = std.io.bufferedReader(stdin_file);
var stdin = br.reader();

fn tokenizeInitialInput(read_buffer: []u8, token_buffer: [][]u8) ![][]u8 {
    var current: usize = 0;
    while (try stdin.readUntilDelimiterOrEof(read_buffer, '\n')) |line| {
        if (line.len == read_buffer.len) {
            // too many chars
        }

        var start: usize = 0;
        for (line, 0..) |char, index| {
            if (char == ' ' and index - start > 0) {
                token_buffer[current] = line[start..index];
                start = index + 1;
                current += 1;
            }
        } else {
            if (start != ' ') {
                token_buffer[current] = line[start..];
                start = line.len;
                current += 1;
            }
        }
        break;
    }
    return token_buffer[0..current];
}

pub fn main() !void {
    while (true) {
        // Print link for command
        try stdout.print("→  ", .{});
        try stdout_flush();
        var read_buffer: [4096]u8 = undefined;
        var token_buffer: [40][:0]u8 = undefined;
        const tokens = try tokenizeInitialInput(&read_buffer, &token_buffer);
        const args = if (tokens.len <= 1) null else tokens[1..];
        const status = execute_commands(tokens[0], args);
        switch (status) {
            ExecutionStatus.Success => {
                try stdout.print("\n", .{});
            },
            ExecutionStatus.Exit => {
                return;
            },
            ExecutionStatus.CommandNotFound => {
                try stdout.print("Err: Command Not Found\n", .{});
            },
            else => {},
        }
        try stdout_flush();
    }
}
