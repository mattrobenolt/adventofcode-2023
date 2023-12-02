const std = @import("std");
const print = std.debug.print;

fn startsWith(haystack: []u8, needle: []const u8) bool {
    return (needle.len <= haystack.len and
        std.mem.eql(u8, needle, haystack[0..needle.len]));
}

fn extractCalibrationValue(line: []u8) u8 {
    var digits = [2]u8{ 0, 0 };
    var first = true;
    var i: usize = 0;

    // print("extracting {s}\n", .{line});

    while (i < line.len) : (i += 1) {
        const c = line[i];
        var digit: u8 = 0;

        switch (c) {
            'o' => {
                // one
                if (startsWith(line[i..], "one")) {
                    // i += "one".len - 1;
                    digit = 1;
                } else continue;
            },
            't' => {
                // two, three
                if (startsWith(line[i..], "two")) {
                    // i += "two".len - 1;
                    digit = 2;
                } else if (startsWith(line[i..], "three")) {
                    // i += "three".len - 1;
                    digit = 3;
                } else continue;
            },
            'f' => {
                // four, five
                if (startsWith(line[i..], "four")) {
                    // i += "four".len - 1;
                    digit = 4;
                } else if (startsWith(line[i..], "five")) {
                    // i += "three".len - 1;
                    digit = 5;
                } else continue;
            },
            's' => {
                // six, seven
                if (startsWith(line[i..], "six")) {
                    // i += "six".len - 1;
                    digit = 6;
                } else if (startsWith(line[i..], "seven")) {
                    // i += "seven".len - 1;
                    digit = 7;
                } else continue;
            },
            'e' => {
                // eight
                if (startsWith(line[i..], "eight")) {
                    // i += "eight".len - 1;
                    digit = 8;
                } else continue;
            },
            'n' => {
                // nine
                if (startsWith(line[i..], "nine")) {
                    // i += "nine".len - 1;
                    digit = 9;
                } else continue;
            },
            '0'...'9' => {
                digit = c - '0';
            },
            else => continue,
        }

        // print("digit = {d}\n", .{digit});

        if (first) {
            digits[0] = digit;
            first = false;
        }
        digits[1] = digit;
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
