const std = @import("std");
const testing = std.testing;

// Import via the zig build module
const zigdom = @import("zigdom");
const dom = zigdom.dom;
const tags = zigdom.tags;

// Import commonly used functions
const attr = dom.attr;
const text = dom.text;
const Node = dom.Node;

// Import tag functions
const section = tags.section;
const div = tags.div;
const img = tags.img;
const h1 = tags.h1;
const h2 = tags.h2;
const p = tags.p;
const a = tags.a;
const span = tags.span;
const svg = tags.svg;
const path = tags.path;
const circle = tags.circle;

// Decode a small set of common HTML entities so comparisons are resilient to encoding differences
fn decodeBasicEntities(src: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    errdefer out.deinit();

    var i: usize = 0;
    while (i < src.len) : (i += 1) {
        const c = src[i];
        if (c == '&') {
            // Try to match a few common named/numeric entities
            if (i + 4 <= src.len and std.mem.eql(u8, src[i .. i + 4], "&lt;")) {
                try out.append('<');
                i += 3; // loop will i += 1
                continue;
            } else if (i + 4 <= src.len and std.mem.eql(u8, src[i .. i + 4], "&gt;")) {
                try out.append('>');
                i += 3;
                continue;
            } else if (i + 5 <= src.len and std.mem.eql(u8, src[i .. i + 5], "&amp;")) {
                try out.append('&');
                i += 4;
                continue;
            } else if (i + 6 <= src.len and std.mem.eql(u8, src[i .. i + 6], "&quot;")) {
                try out.append('"');
                i += 5;
                continue;
            } else if (i + 6 <= src.len and std.mem.eql(u8, src[i .. i + 6], "&apos;")) {
                try out.append('\'');
                i += 5;
                continue;
            } else if (i + 5 <= src.len and std.mem.eql(u8, src[i .. i + 5], "&#39;")) {
                try out.append('\'');
                i += 4;
                continue;
            }
        }
        try out.append(c);
    }

    return out.toOwnedSlice();
}

// Helper function to normalize HTML for comparison
fn normalizeHtml(html: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    errdefer result.deinit();

    var i: usize = 0;
    var in_tag = false;
    var prev_was_space = false;

    while (i < html.len) : (i += 1) {
        const c = html[i];

        if (c == '<') {
            in_tag = true;
            try result.append(c);
            prev_was_space = false;
        } else if (c == '>') {
            in_tag = false;
            try result.append(c);
            prev_was_space = false;
        } else if (in_tag) {
            // Inside tags, preserve everything
            try result.append(c);
            prev_was_space = false;
        } else {
            // Outside tags (in text content)
            if (std.ascii.isWhitespace(c)) {
                // Look ahead to see if next non-whitespace is a '<' (i.e., whitespace between tags)
                var j = i;
                while (j < html.len and std.ascii.isWhitespace(html[j])) : (j += 1) {}
                if (j >= html.len or html[j] == '<') {
                    // Skip emitting whitespace between tags
                    prev_was_space = false;
                    i = j - 1; // loop will i += 1
                } else {
                    if (!prev_was_space) {
                        try result.append(' ');
                        prev_was_space = true;
                    }
                }
            } else {
                try result.append(c);
                prev_was_space = false;
            }
        }
    }

    const collapsed = try result.toOwnedSlice();
    // Decode common entities after collapsing whitespace
    const decoded = try decodeBasicEntities(collapsed, allocator);
    allocator.free(collapsed);
    return decoded;
}

// Inline helper to build a single card for Blog 2 pattern
inline fn blog2Card(title: []const u8) Node {
    return div(&.{attr("class", "p-4 lg:w-1/3")}, &.{
        div(&.{attr("class", "h-full bg-gray-800 bg-opacity-40 px-8 pt-16 pb-24 rounded-lg overflow-hidden text-center relative")}, &.{
            h2(&.{attr("class", "tracking-widest text-xs title-font font-medium text-gray-500 mb-1")}, &.{text("CATEGORY")}),
            h1(&.{attr("class", "title-font sm:text-2xl text-xl font-medium text-white mb-3")}, &.{text(title)}),
            p(&.{attr("class", "leading-relaxed mb-3")}, &.{text("Photo booth fam kinfolk cold-pressed sriracha leggings jianbing microdosing tousled waistcoat.")}),
            a(&.{attr("class", "text-indigo-400 inline-flex items-center")}, &.{
                text("Learn More"),
                svg(&.{
                    attr("class", "w-4 h-4 ml-2"),
                    attr("viewBox", "0 0 24 24"),
                    attr("stroke", "currentColor"),
                    attr("stroke-width", "2"),
                    attr("fill", "none"),
                    attr("stroke-linecap", "round"),
                    attr("stroke-linejoin", "round"),
                }, &.{
                    path(&.{attr("d", "M5 12h14")}, &.{}),
                    path(&.{attr("d", "M12 5l7 7-7 7")}, &.{}),
                }),
            }),
            div(&.{attr("class", "text-center mt-2 leading-none flex justify-center absolute bottom-0 left-0 w-full py-4")}, &.{
                span(&.{attr("class", "text-gray-500 mr-3 inline-flex items-center leading-none text-sm pr-3 py-1 border-r-2 border-gray-700 border-opacity-50")}, &.{
                    svg(&.{
                        attr("class", "w-4 h-4 mr-1"),
                        attr("stroke", "currentColor"),
                        attr("stroke-width", "2"),
                        attr("fill", "none"),
                        attr("stroke-linecap", "round"),
                        attr("stroke-linejoin", "round"),
                        attr("viewBox", "0 0 24 24"),
                    }, &.{
                        path(&.{attr("d", "M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z")}, &.{}),
                        circle(&.{ attr("cx", "12"), attr("cy", "12"), attr("r", "3") }, &.{}),
                    }),
                    text("1.2K"),
                }),
                span(&.{attr("class", "text-gray-500 inline-flex items-center leading-none text-sm")}, &.{
                    svg(&.{
                        attr("class", "w-4 h-4 mr-1"),
                        attr("stroke", "currentColor"),
                        attr("stroke-width", "2"),
                        attr("fill", "none"),
                        attr("stroke-linecap", "round"),
                        attr("stroke-linejoin", "round"),
                        attr("viewBox", "0 0 24 24"),
                    }, &.{
                        path(&.{attr("d", "M21 11.5a8.38 8.38 0 01-.9 3.8 8.5 8.5 0 01-7.6 4.7 8.38 8.38 0 01-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 01-.9-3.8 8.5 8.5 0 014.7-7.6 8.38 8.38 0 013.8-.9h.5a8.48 8.48 0 018 8v.5z")}, &.{}),
                    }),
                    text("6"),
                }),
            }),
        }),
    });
}

test "tailblocks.blog.2.html" {
    const allocator = testing.allocator;

    const layout = section(&.{attr("class", "text-gray-400 bg-gray-900 body-font")}, &.{
        div(&.{attr("class", "container px-5 py-24 mx-auto")}, &.{
            div(&.{attr("class", "flex flex-wrap -m-4")}, &.{
                // Card 1
                blog2Card("Raclette Blueberry Nextious Level"),
                // Card 2
                blog2Card("Ennui Snackwave Thundercats"),
                // Card 3
                blog2Card("Selvage Poke Waistcoat Godard"),
            }),
        }),
    });

    const html_str = try layout.renderToString(allocator);
    defer allocator.free(html_str);

    const file = try std.fs.cwd().openFile("examples/tailblocks/blog/2.html", .{});
    defer file.close();
    const expected_html = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(expected_html);

    const norm_actual = try normalizeHtml(html_str, allocator);
    defer allocator.free(norm_actual);
    const norm_expected = try normalizeHtml(expected_html, allocator);
    defer allocator.free(norm_expected);

    if (!std.mem.eql(u8, norm_actual, norm_expected)) {
        const min_len = @min(norm_actual.len, norm_expected.len);
        var i: usize = 0;
        while (i < min_len and norm_actual[i] == norm_expected[i]) : (i += 1) {}
        const ctx = 60;
        const start = if (i > ctx) i - ctx else 0;
        const end_a = @min(norm_actual.len, i + ctx);
        const end_e = @min(norm_expected.len, i + ctx);
        std.debug.print("\n[Blog 2] Normalized lengths: actual={}, expected={}\n", .{ norm_actual.len, norm_expected.len });
        std.debug.print("[Blog 2] First diff at index {}\n", .{i});
        std.debug.print("[Blog 2] Actual around diff:\n...{s}...\n", .{norm_actual[start..end_a]});
        std.debug.print("[Blog 2] Expected around diff:\n...{s}...\n", .{norm_expected[start..end_e]});
        try testing.expect(false);
    }

    try testing.expect(true);
}

// Inline helper to build a single post for Blog 3 pattern
inline fn blog3Post(title: []const u8, paragraph: []const u8, img_src: []const u8, author: []const u8, role: []const u8) Node {
    return div(&.{attr("class", "p-12 md:w-1/2 flex flex-col items-start")}, &.{
        span(&.{attr("class", "inline-block py-1 px-2 rounded bg-gray-800 text-gray-400 text-opacity-75 text-xs font-medium tracking-widest")}, &.{text("CATEGORY")}),
        h2(&.{attr("class", "sm:text-3xl text-2xl title-font font-medium text-white mt-4 mb-4")}, &.{text(title)}),
        p(&.{attr("class", "leading-relaxed mb-8")}, &.{text(paragraph)}),
        div(&.{attr("class", "flex items-center flex-wrap pb-4 mb-4 border-b-2 border-gray-800 border-opacity-75 mt-auto w-full")}, &.{
            a(&.{attr("class", "text-indigo-400 inline-flex items-center")}, &.{
                text("Learn More"),
                svg(&.{
                    attr("class", "w-4 h-4 ml-2"),
                    attr("viewBox", "0 0 24 24"),
                    attr("stroke", "currentColor"),
                    attr("stroke-width", "2"),
                    attr("fill", "none"),
                    attr("stroke-linecap", "round"),
                    attr("stroke-linejoin", "round"),
                }, &.{
                    path(&.{attr("d", "M5 12h14")}, &.{}),
                    path(&.{attr("d", "M12 5l7 7-7 7")}, &.{}),
                }),
            }),
            span(&.{attr("class", "text-gray-500 mr-3 inline-flex items-center ml-auto leading-none text-sm pr-3 py-1 border-r-2 border-gray-800")}, &.{
                svg(&.{
                    attr("class", "w-4 h-4 mr-1"),
                    attr("stroke", "currentColor"),
                    attr("stroke-width", "2"),
                    attr("fill", "none"),
                    attr("stroke-linecap", "round"),
                    attr("stroke-linejoin", "round"),
                    attr("viewBox", "0 0 24 24"),
                }, &.{
                    path(&.{attr("d", "M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z")}, &.{}),
                    circle(&.{ attr("cx", "12"), attr("cy", "12"), attr("r", "3") }, &.{}),
                }),
                text("1.2K"),
            }),
            span(&.{attr("class", "text-gray-500 inline-flex items-center leading-none text-sm")}, &.{
                svg(&.{
                    attr("class", "w-4 h-4 mr-1"),
                    attr("stroke", "currentColor"),
                    attr("stroke-width", "2"),
                    attr("fill", "none"),
                    attr("stroke-linecap", "round"),
                    attr("stroke-linejoin", "round"),
                    attr("viewBox", "0 0 24 24"),
                }, &.{
                    path(&.{attr("d", "M21 11.5a8.38 8.38 0 01-.9 3.8 8.5 8.5 0 01-7.6 4.7 8.38 8.38 0 01-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 01-.9-3.8 8.5 8.5 0 014.7-7.6 8.38 8.38 0 013.8-.9h.5a8.48 8.48 0 018 8v.5z")}, &.{}),
                }),
                text("6"),
            }),
        }),
        a(&.{attr("class", "inline-flex items-center")}, &.{
            img(&.{ attr("alt", "blog"), attr("src", img_src), attr("class", "w-12 h-12 rounded-full flex-shrink-0 object-cover object-center") }),
            span(&.{attr("class", "flex-grow flex flex-col pl-4")}, &.{
                span(&.{attr("class", "title-font font-medium text-white")}, &.{text(author)}),
                span(&.{attr("class", "text-gray-500 text-xs tracking-widest mt-0.5")}, &.{text(role)}),
            }),
        }),
    });
}

test "tailblocks.blog.3.html" {
    const allocator = testing.allocator;

    const layout = section(&.{attr("class", "text-gray-400 bg-gray-900 body-font overflow-hidden")}, &.{
        div(&.{attr("class", "container px-5 py-24 mx-auto")}, &.{
            div(&.{attr("class", "flex flex-wrap -m-12")}, &.{
                // Post 1
                blog3Post(
                    "Roof party normcore before they sold out, cornhole vape",
                    "Live-edge letterpress cliche, salvia fanny pack humblebrag narwhal portland. VHS man braid palo santo hoodie brunch trust fund. Bitters hashtag waistcoat fashion axe chia unicorn. Plaid fixie chambray 90's, slow-carb etsy tumeric. Cray pug you probably haven't heard of them hexagon kickstarter craft beer pork chic.",
                    "https://dummyimage.com/104x104",
                    "Holden Caulfield",
                    "UI DEVELOPER",
                ),
                // Post 2
                blog3Post(
                    "Pinterest DIY dreamcatcher gentrify single-origin coffee",
                    "Live-edge letterpress cliche, salvia fanny pack humblebrag narwhal portland. VHS man braid palo santo hoodie brunch trust fund. Bitters hashtag waistcoat fashion axe chia unicorn. Plaid fixie chambray 90's, slow-carb etsy tumeric.",
                    "https://dummyimage.com/103x103",
                    "Alper Kamu",
                    "DESIGNER",
                ),
            }),
        }),
    });

    const html_str = try layout.renderToString(allocator);
    defer allocator.free(html_str);

    const file = try std.fs.cwd().openFile("examples/tailblocks/blog/3.html", .{});
    defer file.close();
    const expected_html = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(expected_html);

    const norm_actual = try normalizeHtml(html_str, allocator);
    defer allocator.free(norm_actual);
    const norm_expected = try normalizeHtml(expected_html, allocator);
    defer allocator.free(norm_expected);

    if (!std.mem.eql(u8, norm_actual, norm_expected)) {
        const min_len = @min(norm_actual.len, norm_expected.len);
        var i: usize = 0;
        while (i < min_len and norm_actual[i] == norm_expected[i]) : (i += 1) {}
        const ctx = 60;
        const start = if (i > ctx) i - ctx else 0;
        const end_a = @min(norm_actual.len, i + ctx);
        const end_e = @min(norm_expected.len, i + ctx);
        std.debug.print("\n[Blog 3] Normalized lengths: actual={}, expected={}\n", .{ norm_actual.len, norm_expected.len });
        std.debug.print("[Blog 3] First diff at index {}\n", .{i});
        std.debug.print("[Blog 3] Actual around diff:\n...{s}...\n", .{norm_actual[start..end_a]});
        std.debug.print("[Blog 3] Expected around diff:\n...{s}...\n", .{norm_expected[start..end_e]});
        try testing.expect(false);
    }

    try testing.expect(true);
}

// Inline helper to build a single row for Blog 4 pattern
inline fn blog4Row(row_class: []const u8, title: []const u8) Node {
    return div(&.{attr("class", row_class)}, &.{
        div(&.{attr("class", "md:w-64 md:mb-0 mb-6 flex-shrink-0 flex flex-col")}, &.{
            span(&.{attr("class", "font-semibold title-font text-white")}, &.{text("CATEGORY")}),
            span(&.{attr("class", "mt-1 text-gray-500 text-sm")}, &.{text("12 Jun 2019")}),
        }),
        div(&.{attr("class", "md:flex-grow")}, &.{
            h2(&.{attr("class", "text-2xl font-medium text-white title-font mb-2")}, &.{text(title)}),
            p(&.{attr("class", "leading-relaxed")}, &.{text("Glossier echo park pug, church-key sartorial biodiesel vexillologist pop-up snackwave ramps cornhole. Marfa 3 wolf moon party messenger bag selfies, poke vaporware kombucha lumbersexual pork belly polaroid hoodie portland craft beer.")}),
            a(&.{attr("class", "text-indigo-400 inline-flex items-center mt-4")}, &.{
                text("Learn More"),
                svg(&.{
                    attr("class", "w-4 h-4 ml-2"),
                    attr("viewBox", "0 0 24 24"),
                    attr("stroke", "currentColor"),
                    attr("stroke-width", "2"),
                    attr("fill", "none"),
                    attr("stroke-linecap", "round"),
                    attr("stroke-linejoin", "round"),
                }, &.{
                    path(&.{attr("d", "M5 12h14")}, &.{}),
                    path(&.{attr("d", "M12 5l7 7-7 7")}, &.{}),
                }),
            }),
        }),
    });
}

test "tailblocks.blog.4.html" {
    const allocator = testing.allocator;

    const layout = section(&.{attr("class", "text-gray-400 bg-gray-900 body-font overflow-hidden")}, &.{
        div(&.{attr("class", "container px-5 py-24 mx-auto")}, &.{
            div(&.{attr("class", "-my-8 divide-y-2 divide-gray-800")}, &.{
                // Row 1
                blog4Row("py-8 flex flex-wrap md:flex-nowrap", "Bitters hashtag waistcoat fashion axe chia unicorn"),
                // Row 2
                blog4Row("py-8 flex border-t-2 border-gray-800 flex-wrap md:flex-nowrap", "Meditation bushwick direct trade taxidermy shaman"),
                // Row 3
                blog4Row("py-8 flex border-t-2 border-gray-800 flex-wrap md:flex-nowrap", "Woke master cleanse drinking vinegar salvia"),
            }),
        }),
    });

    const html_str = try layout.renderToString(allocator);
    defer allocator.free(html_str);

    const file = try std.fs.cwd().openFile("examples/tailblocks/blog/4.html", .{});
    defer file.close();
    const expected_html = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(expected_html);

    const norm_actual = try normalizeHtml(html_str, allocator);
    defer allocator.free(norm_actual);
    const norm_expected = try normalizeHtml(expected_html, allocator);
    defer allocator.free(norm_expected);

    if (!std.mem.eql(u8, norm_actual, norm_expected)) {
        const min_len = @min(norm_actual.len, norm_expected.len);
        var i: usize = 0;
        while (i < min_len and norm_actual[i] == norm_expected[i]) : (i += 1) {}
        const ctx = 60;
        const start = if (i > ctx) i - ctx else 0;
        const end_a = @min(norm_actual.len, i + ctx);
        const end_e = @min(norm_expected.len, i + ctx);
        std.debug.print("\n[Blog 4] Normalized lengths: actual={}, expected={}\n", .{ norm_actual.len, norm_expected.len });
        std.debug.print("[Blog 4] First diff at index {}\n", .{i});
        std.debug.print("[Blog 4] Actual around diff:\n...{s}...\n", .{norm_actual[start..end_a]});
        std.debug.print("[Blog 4] Expected around diff:\n...{s}...\n", .{norm_expected[start..end_e]});
        try testing.expect(false);
    }

    try testing.expect(true);
}

// Inline helper to build a single entry for Blog 5 pattern
inline fn blog5Entry(title: []const u8, img_src: []const u8, author: []const u8) Node {
    return div(&.{attr("class", "py-8 px-4 lg:w-1/3")}, &.{
        div(&.{attr("class", "h-full flex items-start")}, &.{
            div(&.{attr("class", "w-12 flex-shrink-0 flex flex-col text-center leading-none")}, &.{
                span(&.{attr("class", "text-gray-400 pb-2 mb-2 border-b-2 border-gray-700")}, &.{text("Jul")}),
                span(&.{attr("class", "font-medium text-lg leading-none text-gray-300 title-font")}, &.{text("18")}),
            }),
            div(&.{attr("class", "flex-grow pl-6")}, &.{
                h2(&.{attr("class", "tracking-widest text-xs title-font font-medium text-indigo-400 mb-1")}, &.{text("CATEGORY")}),
                h1(&.{attr("class", "title-font text-xl font-medium text-white mb-3")}, &.{text(title)}),
                p(&.{attr("class", "leading-relaxed mb-5")}, &.{text("Photo booth fam kinfolk cold-pressed sriracha leggings jianbing microdosing tousled waistcoat.")}),
                a(&.{attr("class", "inline-flex items-center")}, &.{
                    img(&.{ attr("alt", "blog"), attr("src", img_src), attr("class", "w-8 h-8 rounded-full flex-shrink-0 object-cover object-center") }),
                    span(&.{attr("class", "flex-grow flex flex-col pl-3")}, &.{
                        span(&.{attr("class", "title-font font-medium text-white")}, &.{text(author)}),
                    }),
                }),
            }),
        }),
    });
}

test "tailblocks.blog.5.html" {
    const allocator = testing.allocator;

    const layout = section(&.{attr("class", "text-gray-400 bg-gray-900 body-font")}, &.{
        div(&.{attr("class", "container px-5 py-24 mx-auto")}, &.{
            div(&.{attr("class", "flex flex-wrap -mx-4 -my-8")}, &.{
                // Entry 1
                blog5Entry("The 400 Blows", "https://dummyimage.com/103x103", "Alper Kamu"),
                // Entry 2
                blog5Entry("Shooting Stars", "https://dummyimage.com/102x102", "Holden Caulfield"),
                // Entry 3
                blog5Entry("Neptune", "https://dummyimage.com/101x101", "Henry Letham"),
            }),
        }),
    });

    const html_str = try layout.renderToString(allocator);
    defer allocator.free(html_str);

    const file = try std.fs.cwd().openFile("examples/tailblocks/blog/5.html", .{});
    defer file.close();
    const expected_html = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(expected_html);

    const norm_actual = try normalizeHtml(html_str, allocator);
    defer allocator.free(norm_actual);
    const norm_expected = try normalizeHtml(expected_html, allocator);
    defer allocator.free(norm_expected);

    if (!std.mem.eql(u8, norm_actual, norm_expected)) {
        const min_len = @min(norm_actual.len, norm_expected.len);
        var i: usize = 0;
        while (i < min_len and norm_actual[i] == norm_expected[i]) : (i += 1) {}
        const ctx = 60;
        const start = if (i > ctx) i - ctx else 0;
        const end_a = @min(norm_actual.len, i + ctx);
        const end_e = @min(norm_expected.len, i + ctx);
        std.debug.print("\n[Blog 5] Normalized lengths: actual={}, expected={}\n", .{ norm_actual.len, norm_expected.len });
        std.debug.print("[Blog 5] First diff at index {}\n", .{i});
        std.debug.print("[Blog 5] Actual around diff:\n...{s}...\n", .{norm_actual[start..end_a]});
        std.debug.print("[Blog 5] Expected around diff:\n...{s}...\n", .{norm_expected[start..end_e]});
        try testing.expect(false);
    }

    try testing.expect(true);
}
