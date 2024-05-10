const std = @import("std");
const ls = @import("builtins/ls.zig").ls;
const pwd = @import("builtins/pwd.zig").pwd;
const ExecutionStatus = @import("common.zig").ExecutionStatus;
const chdir = @import("builtins/chdir.zig").chdir;
const pid_t = std.posix.pid_t;
const fork = std.posix.fork;
const waitpid = std.posix.waitpid;
const execvpeZ = std.posix.execvpeZ;
fn exit(args: ?[][]u8) ExecutionStatus {
    _ = args;
    return ExecutionStatus.Exit;
}

fn launchProcess(command: [*:0]const u8, args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    const pid: pid_t = fork() catch return ExecutionStatus.CannotFork;
    if (pid == 0) {
        const env = [_:null]?[*:0]u8{null};
        const status = execvpeZ(command, args, &env);
        _ = status;
        // We are the child, execute the command.

    } else {
        const result = waitpid(pid, 0);
        if (result != 0) {
            ExecutionStatus.ChildProcessError;
        }
    }
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
    var cmd: [*:0]u8 = command.ptr;
    cmd[command.len] = 0;

    return launchProcess(command, args);
}
