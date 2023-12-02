const std = @import("std");
const print = std.debug.print;
const startsWith = std.mem.startsWith;

fn matchNumber(s: []const u8, n: []const u8, d: u8) ?u8 {
    if (startsWith(u8, s, n)) return d;
    return null;
}

fn extractCalibrationValue(line: []u8) u8 {
    var digits = [2]u8{ 0, 0 };
    var first = true;
    var i: usize = 0;

    // print("extracting {s}\n", .{line});

    while (i < line.len) : (i += 1) {
        const c = line[i];
        const rest = line[i..];

        if (switch (c) {
            'o' => matchNumber(rest, "one", 1),
            't' => matchNumber(rest, "two", 2) orelse matchNumber(rest, "three", 3),
            'f' => matchNumber(rest, "four", 4) orelse matchNumber(rest, "five", 5),
            's' => matchNumber(rest, "six", 6) orelse matchNumber(rest, "seven", 7),
            'e' => matchNumber(rest, "eight", 8),
            'n' => matchNumber(rest, "nine", 9),
            '0'...'9' => c - '0',
            else => null,
        }) |digit| {
            // print("digit = {d}\n", .{digit});
            if (first) {
                digits[0] = digit;
                first = false;
            }
            digits[1] = digit;
        }
    }

    // print("{} {}\n", .{ digits[0], digits[1] });

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
