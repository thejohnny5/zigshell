const std = @import("std");
const ls = @import("builtins/ls.zig").ls;
const pwd = @import("builtins/pwd.zig").pwd;
const ExecutionInfo = @import("common.zig").ExecutionInfo;
const chdir = @import("builtins/chdir.zig").chdir;
const pid_t = std.posix.pid_t;
const fork = std.posix.fork;
const waitpid = std.posix.waitpid;
const execvpeZ = std.posix.execvpeZ;
const exit = @import("builtins/exit.zig").exit;

fn launchProcess(command: [*:0]const u8, args: [*:null]const ?[*:0]const u8) ExecutionInfo {
    const pid: pid_t = fork() catch return ExecutionInfo{ .execution_status = .CannotFork, .msg = "cannot fork", .display = true };
    if (pid == @as(pid_t, 0)) {
        const env = [_:null]?[*:0]u8{null};
        const err_res = execvpeZ(command, args, &env);
        std.debug.print("zshell: {}\n", .{err_res});
        std.posix.exit(0);
    } else {
        const result = waitpid(pid, 0);
        _ = result;
        return ExecutionInfo{ .execution_status = .Success, .msg = "" };
    }
}

pub fn execute_commands(command: [*:0]u8, args: [*:null]const ?[*:0]const u8) ExecutionInfo {
    const len = std.mem.len(command);
    const cmd = command[0..len];
    if (std.mem.eql(u8, cmd, "exit")) {
        return exit(args);
    }
    //if (std.mem.eql(u8, command, "ls")) {
    //    return ls(args);
    //}
    if (std.mem.eql(u8, cmd, "pwd")) {
        return pwd(args);
    }
    if (std.mem.eql(u8, cmd, "cd")) {
        return chdir(args);
    }

    return launchProcess(command, args);
}
