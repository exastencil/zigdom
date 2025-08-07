const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // Expose the library as a module named "zigdom" (for dependency consumers)
    const zigdom = b.addModule("zigdom", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{ .root_module = zigdom });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Run all tests
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Test step for tailblocks examples
    const tailblocks = b.createModule(.{
        .root_source_file = b.path("examples/tailblocks.zig"),
        .target = target,
        .optimize = optimize,
    });
    tailblocks.addImport("zigdom", zigdom);
    const test_tailblocks = b.addTest(.{ .root_module = tailblocks });
    test_step.dependOn(&b.addRunArtifact(test_tailblocks).step);
}
