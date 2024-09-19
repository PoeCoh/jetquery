const std = @import("std");

const jetquery = @import("../jetquery.zig");

/// A bound parameter (e.g. used in a where clause).
pub const Value = union(enum) {
    string: []const u8,
    integer: usize,
    float: f64,
    boolean: bool,
    Null: void,
    err: anyerror,

    pub fn toSql(self: Value, buf: []u8, adapter: jetquery.adapters.Adapter, index: usize) ![]const u8 {
        return try adapter.paramSql(buf, self, index);
        // var stream = std.io.fixedBufferStream(buf);
        // switch (self) {
        //     .string => |value| try writer.print("'{s}'", .{value}),
        //     .integer => |value| try writer.print("{}", .{value}),
        //     .float => |value| try writer.print("{d}", .{value}),
        //     .boolean => |value| try writer.print("{}", .{@as(u1, if (value) 1 else 0)}),
        //     .Null => try writer.print("NULL", .{}),
        //     .err => |err| return err,
        // }
        // return stream.getWritten();
    }

    pub fn eql(self: Value, other: Value) bool {
        return switch (self) {
            .string => |value| other == .string and std.mem.eql(u8, value, other.string),
            .integer => |value| other == .integer and value == other.integer,
            .float => |value| other == .float and value == other.float,
            .boolean => |value| other == .boolean and value == other.boolean,
            .Null => other == .Null,
            .err => false,
        };
    }

    pub fn PG() void {}
};
