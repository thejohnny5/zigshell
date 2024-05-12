const std = @import("std");
const ls = @import("builtins/ls.zig").ls;
const pwd = @import("builtins/pwd.zig").pwd;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const chdir = @import("builtins/chdir.zig").chdir;
const pid_t = std.posix.pid_t;
const fork = std.posix.fork;
const waitpid = std.posix.waitpid;
const execvpeZ = std.posix.execvpeZ;
fn exit(args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    _ = args;
    std.debug.print("Hit\n", .{});
    return ExecutionStatus.Exit;
}

fn launchProcess(command: [*:0]const u8, args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    const pid: pid_t = fork() catch return ExecutionStatus.CannotFork;
    if (pid == @as(pid_t, 0)) {
        const env = [_:null]?[*:0]u8{null};
        const err_res = execvpeZ(command, args, &env);
        std.debug.print("ERROR: {}\n", .{err_res});
        std.posix.exit(0);
    } else {
        const result = waitpid(pid, 0);
        _ = result;
        return ExecutionStatus.Success;
    }
}

pub fn execute_commands(command: [*:0]u8, args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    const len = std.mem.len(command);
    const cmd = command[0..len];
    if (std.mem.eql(u8, cmd, "exit")) {
        return exit(args);
    }
    //if (std.mem.eql(u8, command, "ls")) {
    //    return ls(args);
    //}
    //if (std.mem.eql(u8, command, "pwd")) {
    //    return pwd(args);
    //}
    if (std.mem.eql(u8, cmd, "cd")) {
        return chdir(args);
    }

    return launchProcess(command, args);
}
