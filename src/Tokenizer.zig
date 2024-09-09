const std = @import("std");
const Self = @This();
pub const TokenType = enum {
    word,
    string_literal,
    pipe,
    write_out,
    read_in,
    invalid,
    eof,

    pub fn lexeme(tt: TokenType) []const u8 {
        return switch (tt) {
            .word => "Word argument",
            .string_literal => "String literal",
            .pipe => "|",
            .read_in => "<",
            .write_out => ">",
            .eof => "end of file",
            else => unreachable,
        };
    }
};

pub const Token = struct {
    tag: TokenType,
    start: usize,
    end: usize,
};

const State = enum {
    start,
    word,
    string_literal,
    invalid,
    eof,
};

buffer: [:0]u8,
idx: usize,

pub fn init(buffer: [:0]u8) Self {
    return .{ .idx = 0, .buffer = buffer };
}

pub fn next(self: *Self) Token {
    var result: Token = .{
        .tag = undefined,
        .start = self.idx,
        .end = undefined,
    };
    var state: State = .start;
    while (self.idx < self.buffer.len) : (self.idx += 1) {
        const c = self.buffer[self.idx];
        switch (state) {
            .start => switch (c) {
                0 => {
                    result.tag = .eof;
                    self.idx += 1;
                    return result;
                },
                ' ', '\r', '\t' => {
                    self.buffer[self.idx] = 0;
                    result.start = self.idx + 1;
                },
                '"' => {
                    state = .string_literal;
                    result.tag = .string_literal;
                },
                33, 35...127 => {
                    state = .word;
                    result.tag = .word;
                },
                else => unreachable,
            },
            .string_literal => switch (c) {
                '"' => {
                    self.idx += 1;
                    result.end = self.idx;
                    return result;
                },
                0x01...0x09, 0x0b...0x1f, 0x7f => {
                    state = .invalid;
                },
                else => continue,
            },
            .invalid => {
                result.tag = .invalid;
                self.idx += 1;
                return result;
            },
            .word => {
                switch (c) {
                    'a'...'z', 'A'...'Z', '_', '0'...'9' => continue,
                    else => {
                        result.end = self.idx;
                        return result;
                    },
                }
            },
            else => unreachable,
        }
    }
    result.end = self.idx;
    if (result.start == self.idx) {
        result.tag = .eof;
    }
    return result;
}
