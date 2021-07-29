const std = @import("std");

/// Configure this to your liking. Must be able to divide 128 evenly
const columns = 4;

pub fn main() anyerror!void {
    var stdout = std.io.getStdOut().writer();

    const count_per_col = @divExact(128, columns);
    {
        var col: u8 = 0;
        while (col < columns) : (col += 1) {
            if (col > 0)
                try stdout.writeAll(" | ");

            try stdout.writeAll("DEC HEX OCT  CHR");
        }
        try stdout.writeAll("\n");

        col = 0;
        while (col < columns) : (col += 1) {
            if (col > 0)
                try stdout.writeAll("-|-");

            try stdout.writeAll("----------------");
        }
        try stdout.writeAll("\n");
    }

    var row: u8 = 0;
    while (row < count_per_col) : (row += 1) {
        var c = row;

        var col: u8 = 0;
        while (col < columns) : (col += 1) {
            var str_buf: [4]u8 = undefined;

            const str_rep = if (std.ascii.isCntrl(c))
                inline for (std.meta.declarations(std.ascii.control_code)) |decl| {
                    if (@field(std.ascii.control_code, decl.name) == c)
                        break decl.name;
                } else unreachable
            else
                try std.fmt.bufPrint(&str_buf, "'{c}'", .{c});

            if (col > 0)
                try stdout.writeAll(" | ");

            try stdout.print("{d: >3} {x: >3} {o: >3}  {s: <3}", .{ c, c, c, str_rep });

            c += count_per_col;
        }
        try stdout.writeAll("\n");
    }
}
