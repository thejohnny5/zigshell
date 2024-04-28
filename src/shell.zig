const std = @import("std");
const ls = @import("commands/ls.zig").ls;
const ExecutionStatus = @import("common.zig").ExecutionStatus;

fn exit(args: [][]u8) ExecutionStatus {
    _ = args;
    return ExecutionStatus.Exit;
}

pub fn execute_commands(command: []u8, args: [][]u8) ExecutionStatus {
    if (std.mem.eql(u8, command, "exit")) {
        return exit(args);
    }
    if (std.mem.eql(u8, command, "ls")) {
        return ls(args);
    }

    return ExecutionStatus.CommandNotFound;
}
