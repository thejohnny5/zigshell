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

fn launchProcess(cmd: [*:0]const u8, arguments: []?[*:0]const u8) ExecutionInfo {
    const command = cmd;
    std.debug.print("Command: {s}: len: {d}\n", .{ cmd, std.mem.len(cmd) });
    //const args: [*:null]?[*:0]u8 = @ptrCast(arguments.ptr);
    const args: [*:null]?[*:0]const u8 = @ptrCast(arguments.ptr);
    std.debug.print("Args: {any}\n", .{std.mem.len(args)});
    std.debug.print("Arguments: {?s}\n", .{args[0]});
    std.debug.print("Arguments: {?s}\n", .{args[1]});
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

pub fn executeCommands(cmd: [:0]u8, args: []?[*:0]const u8) ExecutionInfo {
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

    std.debug.print("Args Len Slice: {any}\n", .{args.len});
    std.debug.print("Slice Arg: {?s}\n", .{args[0]});
    //return ExecutionInfo{ .execution_status = .Success, .msg = "Test", .display = false };
    std.debug.print("Address exec commands: {*}, {*}, {*}\n", .{ &args, args.ptr, &args[0].? });
    return launchProcess(cmd.ptr, args);
}
