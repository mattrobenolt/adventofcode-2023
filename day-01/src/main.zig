const std = @import("std");
const print = std.debug.print;

fn extractCalibrationValue(line: []u8) u8 {
    var digits: [2]u8 = undefined;
    var first: bool = true;

    for (line[0..]) |c| {
        switch (c) {
            '0'...'9' => {
                const digit = c - '0';
                if (first) {
                    digits[0] = digit;
                    first = false;
                }
                digits[1] = digit;
            },
            else => {},
        }
    }

    return (digits[0] * 10) + digits[1];
}
pub fn main() !void {
    const stdin = std.io.getStdIn().reader();

    var buf: [1024]u8 = undefined;
    var sum: u64 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const value = extractCalibrationValue(line);
        sum += value;
        print("{s} = {d}\n", .{ line, value });
    }

    print("======\n", .{});
    print("total: {d}\n", .{sum});
}
