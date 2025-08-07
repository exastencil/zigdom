//! Example demonstrating the ZigDOM library usage

const std = @import("std");
const zigdom = @import("zigdom");
const dom = zigdom.dom;
const tags = zigdom.tags;

// Import helpers
const attr = dom.attr;
const text = dom.text;
const Node = dom.Node;

pub fn main() !void {
    // Create a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create a simple HTML page structure
    const page = createSamplePage();

    // Render to stdout
    const stdout = std.io.getStdOut().writer();
    try stdout.writeAll("Generated HTML:\n\n");
    try page.render(stdout);
    try stdout.writeAll("\n\n");

    // Also demonstrate rendering to a string
    const html_string = try page.renderToString(allocator);
    defer allocator.free(html_string);

    try stdout.print("String length: {} bytes\n", .{html_string.len});
}

fn createSamplePage() Node {
    // Create a complete HTML document using the tags API
    return tags.html(&.{attr("lang", "en")}, &.{
        tags.head(&.{}, &.{
            tags.meta(&.{attr("charset", "UTF-8")}),
            tags.title(&.{}, &.{
                text("ZigDOM Example Page"),
            }),
        }),
        tags.body(&.{}, &.{
            tags.h1(&.{}, &.{
                text("Welcome to ZigDOM!"),
            }),
            tags.p(&.{}, &.{
                text("This is a "),
                tags.strong(&.{}, &.{
                    text("DOM library"),
                }),
                text(" written in Zig."),
            }),
            tags.ul(&.{attr("class", "feature-list")}, &.{
                tags.li(&.{}, &.{text("No template files needed")}),
                tags.li(&.{}, &.{text("Type-safe DOM construction")}),
                tags.li(&.{}, &.{text("Automatic HTML escaping")}),
                tags.li(&.{}, &.{text("Recursive rendering")}),
            }),
            tags.img(&.{
                attr("src", "/logo.png"),
                attr("alt", "ZigDOM Logo"),
                attr("width", "200"),
            }),
        }),
    });
}

