const std = @import("std");
const Build = std.Build;
const MicroZig = @import("microzig/build");

fn path(comptime suffix: []const u8) Build.LazyPath {
    return .{
        .cwd_relative = comptime ((std.fs.path.dirname(@src().file) orelse ".") ++ suffix),
    };
}

const hal = .{
    .root_source_file = path("/src/hals/ATmega328P.zig"),
};

pub const chips = struct {
    pub const atmega328p = MicroZig.Target{
        .preferred_format = .hex,
        .chip = .{
            .name = "ATmega328P",
            .url = "https://www.microchip.com/en-us/product/atmega328p",
            .cpu = MicroZig.cpus.avr5,
            .register_definition = .{
                .json = path("/src/chips/ATmega328P.json"),
            },
            .memory_regions = &.{
                .{ .offset = 0x000000, .length = 32 * 1024, .kind = .flash },
                .{ .offset = 0x800100, .length = 2048, .kind = .ram },
            },
        },
        .hal = hal,
    };
};

pub const boards = struct {
    pub const arduino = struct {
        pub const nano = MicroZig.Target{
            .preferred_format = .hex,
            .chip = chips.atmega328p.chip,
            .hal = hal,
            .board = .{
                .name = "Arduino Nano",
                .url = "https://docs.arduino.cc/hardware/nano",
                .root_source_file = path("/src/boards/arduino_nano.zig"),
            },
        };

        pub const uno_rev3 = MicroZig.Target{
            .preferred_format = .hex,
            .chip = chips.atmega328p.chip,
            .hal = hal,
            .board = .{
                .name = "Arduino Uno",
                .url = "https://docs.arduino.cc/hardware/uno-rev3",
                .root_source_file = path("/src/boards/arduino_uno.zig"),
            },
        };
    };
};

pub fn build(b: *Build) void {
    _ = b.step("test", "Run platform agnostic unit tests");
}
