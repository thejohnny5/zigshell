const ExecutionStatus = @import("../common.zig").ExecutionStatus;

pub fn exit(args: [*:null]const ?[*:0]const u8) ExecutionStatus {
    _ = args;
    return ExecutionStatus.Exit;
}
