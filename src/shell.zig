const std = @import("std");
const ls = @import("commands/ls.zig").ls;
const pwd = @import("commands/pwd.zig").pwd;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const chdir = @import("commands/chdir.zig").chdir;
fn exit(args: ?[][]u8) ExecutionStatus {
    _ = args;
    return ExecutionStatus.Exit;
}

pub fn execute_commands(command: []u8, args: ?[][]u8) ExecutionStatus {
    if (std.mem.eql(u8, command, "exit")) {
        return exit(args);
    }
    if (std.mem.eql(u8, command, "ls")) {
        return ls(args);
    }
    if (std.mem.eql(u8, command, "pwd")) {
        return pwd(args);
    }
    if (std.mem.eql(u8, command, "cd")) {
        return chdir(args);
    }

    return ExecutionStatus.CommandNotFound;
}
