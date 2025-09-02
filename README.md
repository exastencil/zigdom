# ZigDOM

A Zig library for constructing DOM trees as pure values (no internal
allocations) and rendering them to a writer or to a string.

Build type-safe, reusable HTML components using functions and
enums — no template files.

## Features

- 🔧 No template files — Build HTML programmatically with full type safety
- 🛡️ Automatic HTML escaping — Text content is escaped to prevent XSS
- 🌳 Recursive rendering — Nested components render seamlessly
- 📦 Memory efficient — Direct-to-writer rendering avoids intermediate strings
- 🎯 Simple, value-based API — Nodes are plain structs, constructed from slices

## Installation

Add ZigDOM to your `build.zig.zon` dependencies (using Zig's package manager):

```zig
.dependencies = .{
    .zigdom = .{
        // Use `zig fetch --save https://github.com/exastencil/zigdom/archive/refs/heads/main.tar.gz`
        // then copy the generated .hash here
        .url = "https://github.com/exastencil/zigdom/archive/refs/heads/main.tar.gz",
        .hash = "...",
    },
};
```

Then in your `build.zig`:

```zig
const zigdom_dep = b.dependency("zigdom", .{ .target = target, .optimize = optimize });
exe.root_module.addImport("zigdom", zigdom_dep.module("zigdom"));
```

Minimum Zig version: see `build.zig.zon` (currently 0.15.0).

## Usage

### Basic example (value-based API)

```zig
const std = @import("std");
const zigdom = @import("zigdom");
const dom = zigdom.dom;
const tags = zigdom.tags;

const attr = dom.attr;
const text = dom.text;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Build a simple HTML structure as pure values
    const page = tags.div(&.{ attr("class", "container") }, &.{
        tags.p(&.{}, &.{ text("Hello, World!") }),
    });

    // Render to stdout (no allocation in ZigDOM)
    const stdout = std.io.getStdOut().writer();
    try page.render(stdout);
    try stdout.writeAll("\n");

    // Or render to a string (allocates; you free it)
    const html = try page.renderToString(allocator);
    defer allocator.free(html);
}
```

### Node types

ZigDOM supports the following node types via `dom.Tag`:

- Elements (e.g. div, p, img, svg, ...)
- Text
- Document (root container)
- Fragment (invisible container)
- Custom elements (by tag name)

Note: There is currently no separate Comment node.

### Creating nodes

Use helpers from `dom` and `tags`:

```zig
const dom = zigdom.dom;
const tags = zigdom.tags;
const attr = dom.attr;
const text = dom.text;

// Element via tag enum
const el = dom.tag(.div, &.{ attr("class", "box") }, &.{});

// Nicer syntax via generated tag functions
const div = tags.div(&.{ attr("class", "box") }, &.{});

// Text node
const t = text("Hello!");

// Fragment
const frag = dom.tag(.fragment, &.{}, &.{ div, t });

// Custom element
const custom = dom.custom("my-widget", &.{ attr("data-id", "123") }, &.{ text("Content") });
```

### Working with elements (immutably)

Nodes are plain values you construct with attributes and children slices:

```zig
const card = tags.div(
    &.{ attr("class", "card") },
    &.{
        tags.h2(&.{}, &.{ text("Title") }),
        tags.p(&.{}, &.{ text("Body text") }),
    },
);
```

Void elements (like img, br, hr, ...) are handled automatically; they render without a closing tag. There is no `self_closing` flag to set.

### Rendering

```zig
// Render to any writer (no allocation inside ZigDOM)
try node.render(writer);

// Render to a string (allocates; you must free)
const html = try node.renderToString(allocator);
defer allocator.free(html);
```

## Memory management and lifetimes

- Construction:
  - Nodes are pure values; creating nodes does not allocate.
  - Attributes (`dom.Attribute`) and children are provided as slices you own.
  - Text nodes keep a slice of your provided bytes.
- Lifetimes:
  - Any slices you pass (attribute names/values, text content, custom tag names, children arrays) must remain valid until rendering is complete.
  - String literals are fine. If you build strings dynamically, keep their backing memory alive until after `render`/`renderToString` finishes.
- Rendering:
  - `render(writer)` does not allocate within ZigDOM.
  - `renderToString(allocator)` allocates a buffer and returns an owned slice that you must free with the same allocator.
- Destruction:
  - There is no `deinit` for `Node`; simply let values go out of scope. Only free what you allocated (e.g. strings you created and the result of `renderToString`).

## Building components

You can create reusable component functions that return `dom.Node` values:

```zig
const std = @import("std");
const zigdom = @import("zigdom");
const dom = zigdom.dom;
const tags = zigdom.tags;
const attr = dom.attr;
const text = dom.text;
const Node = dom.Node;

fn Card(title: []const u8, content: []const u8) Node {
    return tags.div(&.{ attr("class", "card") }, &.{
        tags.h2(&.{}, &.{ text(title) }),
        tags.p(&.{}, &.{ text(content) }),
    });
}
```

## Running tests

```bash
zig build test
```

## Running the example

```bash
zig build run
```

## License

[![Hippocratic License HL3-ECO-FFD](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-ECO-FFD&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/eco-ffd.html)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
