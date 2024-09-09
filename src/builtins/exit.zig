const ExecutionInfo = @import("../common.zig").ExecutionInfo;

pub fn exit(args: []?[*:0]const u8) ExecutionInfo {
    _ = args;
    return ExecutionInfo{ .execution_status = .Exit, .msg = "" };
}
