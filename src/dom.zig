//! Unified DOM implementation
//! Everything is a Node with attributes and children
//! Nodes are pure values with no allocations

const std = @import("std");

/// Tag types for HTML elements
// zig fmt: off
pub const Tag = enum {
    // Special nodes
    text, document, fragment, custom,

    // Void elements (self-closing)
    area, base, br, col, embed, hr, img, input, link, meta, param, source, track, wbr,

    // Text formatting
    a, abbr, b, cite, code, del, dfn, em, i, ins, kbd, mark, q, s, samp, small, strong, sub, sup, time, u, var_tag,

    // Headings and content
    h1, h2, h3, h4, h5, h6, p, pre, blockquote,

    // Lists
    dd, dl, dt, li, ol, ul,

    // Structure and layout  
    address, article, aside, body, div, footer, head, header, hgroup, html, main, nav, section, span,

    // Forms (excluding duplicates already in void elements)
    button, datalist, fieldset, form, label, legend, meter, optgroup, option, output, progress, select, textarea,

    // Tables (excluding col which is in void elements)
    caption, colgroup, table, tbody, td, tfoot, th, thead, tr,

    // Media and embedded content (excluding img which is in void elements)
    audio, canvas, figure, figcaption, iframe, map, object, picture, svg, video,

    // Other elements
    data, details, dialog, menu, noscript, rp, rt, ruby, script, style, summary, template, title,

    // SVG elements
    circle, clipPath, defs, ellipse, g, line, linearGradient, mask,
    path, pattern, polygon, polyline, radialGradient, rect, stop, symbol, use,
    
    pub fn isVoid(self: Tag) bool {
        return switch (self) {
            .area, .base, .br, .col, .embed, .hr, .img, .input, .link, .meta, .param, .source, .track, .wbr => true,
            else => false,
        };
    }

    pub fn isInvisible(self: Tag) bool {
        return switch (self) {
            .document, .fragment => true,
            else => false,
        };
    }

    pub fn name(self: Tag) []const u8 {
        return switch (self) {
            .text => "",
            .document => "",
            .fragment => "",
            .custom => "",
            .var_tag => "var",
            else => @tagName(self),
        };
    }
};
// zig fmt: on

/// Attribute for HTML elements
pub const Attribute = struct {
    name: []const u8,
    value: []const u8,
};

/// Unified Node structure - pure value type with no allocations
/// Format: {tag, attributes, children} or {.text, {}, text_content}
pub const Node = struct {
    tag: Tag,
    attributes: []const Attribute,
    children: union(enum) {
        nodes: []const Node,
        text: []const u8,
        custom: struct {
            tag_name: []const u8,
            children: []const Node,
        },
    },

    /// Render the node to a writer
    pub fn render(self: Node, writer: anytype) anyerror!void {
        switch (self.tag) {
            .text => {
                // Render text content with HTML escaping
                const text_content = switch (self.children) {
                    .text => |t| t,
                    else => "",
                };
                for (text_content) |c| {
                    switch (c) {
                        '<' => try writer.writeAll("&lt;"),
                        '>' => try writer.writeAll("&gt;"),
                        '&' => try writer.writeAll("&amp;"),
                        '"' => try writer.writeAll("&quot;"),
                        '\'' => try writer.writeAll("&#39;"),
                        else => try writer.writeByte(c),
                    }
                }
            },
            .document => {
                // Special case
                try writer.writeAll("<!DOCTYPE html>\n");
                const nodes = switch (self.children) {
                    .nodes => |nodes_array| nodes_array,
                    else => &.{},
                };
                for (nodes) |child| {
                    try child.render(writer);
                }
            },
            .fragment => {
                // Invisible container - just render children
                const nodes = switch (self.children) {
                    .nodes => |nodes_array| nodes_array,
                    else => &.{},
                };
                for (nodes) |child| {
                    try child.render(writer);
                }
            },
            .custom => {
                // Custom elements
                const custom_elem = switch (self.children) {
                    .custom => |c| c,
                    else => unreachable,
                };

                // Opening tag
                try writer.print("<{s}", .{custom_elem.tag_name});

                // Attributes
                for (self.attributes) |attribute| {
                    try writer.print(" {s}=\"{s}\"", .{ attribute.name, attribute.value });
                }

                // Close opening tag
                try writer.writeAll(">");

                // Children and closing tag
                for (custom_elem.children) |child| {
                    try child.render(writer);
                }
                try writer.print("</{s}>", .{custom_elem.tag_name});
            },
            else => {
                // Regular elements
                const tag_name = self.tag.name();

                // Opening tag
                try writer.print("<{s}", .{tag_name});

                // Attributes
                for (self.attributes) |attribute| {
                    try writer.print(" {s}=\"{s}\"", .{ attribute.name, attribute.value });
                }

                // Close opening tag
                try writer.writeAll(">");

                // Children and closing tag (unless void element)
                if (!self.tag.isVoid()) {
                    const nodes = switch (self.children) {
                        .nodes => |nodes_array| nodes_array,
                        else => &.{},
                    };
                    for (nodes) |child| {
                        try child.render(writer);
                    }
                    try writer.print("</{s}>", .{tag_name});
                }
            },
        }
    }

    /// Render to a string
    pub fn renderToString(self: Node, allocator: std.mem.Allocator) ![]u8 {
        var list = std.ArrayList(u8).init(allocator);
        errdefer list.deinit();
        try self.render(list.writer());
        return try list.toOwnedSlice();
    }
};

// Helper function for creating attributes
pub fn attr(name: []const u8, value: []const u8) Attribute {
    return .{ .name = name, .value = value };
}

// Helper function for creating text nodes
pub fn text(content: []const u8) Node {
    return Node{
        .tag = .text,
        .attributes = &.{},
        .children = .{ .text = content },
    };
}

// Helper function for creating nodes with tuple-like syntax
pub fn tag(tag_type: Tag, attributes: []const Attribute, children: []const Node) Node {
    // For custom elements, we need special handling
    if (tag_type == .custom) {
        // In this case, children should be a special custom struct
        // but for simplicity, we'll just use a regular element
        return Node{
            .tag = tag_type,
            .attributes = attributes,
            .children = .{ .nodes = children },
        };
    }

    return Node{
        .tag = tag_type,
        .attributes = attributes,
        .children = .{ .nodes = children },
    };
}

// Helper function for creating custom elements
pub fn custom(tag_name: []const u8, attributes: []const Attribute, children: []const Node) Node {
    return Node{
        .tag = .custom,
        .attributes = attributes,
        .children = .{ .custom = .{
            .tag_name = tag_name,
            .children = children,
        } },
    };
}

// Tests

const testing = std.testing;

test "create simple element" {
    const allocator = testing.allocator;

    const div = tag(.div, &.{}, &.{});

    const html = try div.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<div></div>", html);
}

test "element with attributes" {
    const allocator = testing.allocator;

    const div = tag(.div, &.{
        attr("class", "container"),
        attr("id", "main"),
    }, &.{});

    const html = try div.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<div class=\"container\" id=\"main\"></div>", html);
}

test "nested elements with text" {
    const allocator = testing.allocator;

    const div = tag(.div, &.{}, &.{
        tag(.p, &.{}, &.{
            text("Hello, World!"),
        }),
    });

    const html = try div.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<div><p>Hello, World!</p></div>", html);
}

test "void elements" {
    const allocator = testing.allocator;

    const div = tag(.div, &.{}, &.{
        tag(.img, &.{
            attr("src", "image.png"),
            attr("alt", "Test"),
        }, &.{}),
    });

    const html = try div.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<div><img src=\"image.png\" alt=\"Test\"></div>", html);
}

test "whole document" {
    const allocator = testing.allocator;

    const doc = tag(.document, &.{}, &.{
        tag(.html, &.{}, &.{
            tag(.head, &.{}, &.{
                tag(.title, &.{}, &.{text("Test")}),
            }),
            tag(.body, &.{}, &.{
                text("Description"),
            }),
        }),
    });

    const html = try doc.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<!DOCTYPE html>\n<html><head><title>Test</title></head><body>Description</body></html>", html);
}

test "document fragment" {
    const allocator = testing.allocator;

    const frag = tag(.fragment, &.{}, &.{
        tag(.p, &.{}, &.{
            text("First"),
        }),
        tag(.p, &.{}, &.{
            text("Second"),
        }),
    });

    const html = try frag.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<p>First</p><p>Second</p>", html);
}

test "HTML escaping in text" {
    const allocator = testing.allocator;

    const p = tag(.p, &.{}, &.{
        text("<script>alert('XSS')</script>"),
    });

    const html = try p.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<p>&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;</p>", html);
}

test "custom elements" {
    const allocator = testing.allocator;

    const div = tag(.div, &.{}, &.{
        custom("my-component", &.{
            attr("data-id", "123"),
        }, &.{
            text("Custom content"),
        }),
    });

    const html = try div.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<div><my-component data-id=\"123\">Custom content</my-component></div>", html);
}

test "complex nested structure" {
    const allocator = testing.allocator;

    const section = tag(.section, &.{attr("class", "blog")}, &.{
        tag(.article, &.{}, &.{
            tag(.h1, &.{}, &.{
                text("Title"),
            }),
            tag(.p, &.{}, &.{
                text("Some "),
                tag(.em, &.{}, &.{
                    text("emphasized"),
                }),
                text(" text."),
            }),
        }),
    });

    const html = try section.renderToString(allocator);
    defer allocator.free(html);

    try testing.expectEqualStrings("<section class=\"blog\"><article><h1>Title</h1><p>Some <em>emphasized</em> text.</p></article></section>", html);
}
