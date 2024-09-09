const std = @import("std");
const Tokenizer = @import("Tokenizer.zig");
const Allocator = std.mem.Allocator;
const Self = @This();
const Token = Tokenizer.Token;
const stdin = std.io.getStdIn().reader();
tokens: std.ArrayListUnmanaged(Token),
allocator: Allocator,
input: [:0]u8,
const CAPACITY: usize = 16;

pub fn init(allocator: Allocator) !Self {
    const tokens = try std.ArrayListUnmanaged(Token).initCapacity(allocator, CAPACITY);
    return .{ .allocator = allocator, .tokens = tokens, .input = undefined };
}

pub const ParserError = error{
    invalid_token,
    exceed_buffer,
};

pub fn parse(self: *Self, input: [:0]u8) !void {
    var tokenizer = Tokenizer.init(input);
    var token = tokenizer.next();
    while (token.tag != .eof) {
        std.debug.print("Token: {any}\n", .{token});
        if (token.tag == .invalid) {
            return ParserError.invalid_token;
        }
        try self.tokens.append(self.allocator, token);
        token = tokenizer.next();
    }
}

pub fn tokenizeInitialInput(self: *Self, read_buffer: [:0]u8) !void {
    self.input = read_buffer;
    const line = try stdin.readUntilDelimiterOrEof(self.input, '\n') orelse return;

    std.debug.print("Line: {s}", .{line});
    if (line.len == self.input.len) {
        return ParserError.exceed_buffer;
    }
    self.input[line.len] = 0;
    const sline: [:0]u8 = self.input[0..line.len :0];
    try self.parse(sline);
}

pub fn free(self: *Self) void {
    self.tokens.clearRetainingCapacity();
}

pub fn getCommand(self: *Self) ?[:0]u8 {
    if (self.tokens.items.len == 0) return null;
    const cmd = self.tokens.items[0];
    return self.input[cmd.start..cmd.end :0];
}
pub fn getArgs(self: *Self, buffer: []?[*:0]u8) []?[*:0]u8 {
    for (self.tokens.items, 0..) |item, i| {
        buffer[i] = self.input[item.start..item.end :0].ptr;

        std.debug.print("Buffer ({d}): {?s}: {any}\n", .{ i, buffer[i], buffer[i] });
    }
    std.debug.print("Address getArgs: {*}, , {*}\n", .{ &buffer, &buffer[0].? });
    return buffer[0..self.tokens.items.len :null];
}
