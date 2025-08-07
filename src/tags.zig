//! HTML tag helper functions for markup-like syntax
//! Each function wraps dom.tag() for cleaner code

const std = @import("std");
const dom = @import("dom.zig");

// Re-export commonly used types
pub const Node = dom.Node;
pub const Attribute = dom.Attribute;

// Re-export helper functions
pub const attr = dom.attr;
pub const text = dom.text;
pub const custom = dom.custom;

// Special nodes
pub fn document(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.document, attrs, children);
}

pub fn fragment(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.fragment, attrs, children);
}

// Void elements (self-closing)
pub fn area(attrs: []const Attribute) Node {
    return dom.tag(.area, attrs, &.{});
}

pub fn base(attrs: []const Attribute) Node {
    return dom.tag(.base, attrs, &.{});
}

pub fn br(attrs: []const Attribute) Node {
    return dom.tag(.br, attrs, &.{});
}

pub fn col(attrs: []const Attribute) Node {
    return dom.tag(.col, attrs, &.{});
}

pub fn embed(attrs: []const Attribute) Node {
    return dom.tag(.embed, attrs, &.{});
}

pub fn hr(attrs: []const Attribute) Node {
    return dom.tag(.hr, attrs, &.{});
}

pub fn img(attrs: []const Attribute) Node {
    return dom.tag(.img, attrs, &.{});
}

pub fn input(attrs: []const Attribute) Node {
    return dom.tag(.input, attrs, &.{});
}

pub fn link(attrs: []const Attribute) Node {
    return dom.tag(.link, attrs, &.{});
}

pub fn meta(attrs: []const Attribute) Node {
    return dom.tag(.meta, attrs, &.{});
}

pub fn param(attrs: []const Attribute) Node {
    return dom.tag(.param, attrs, &.{});
}

pub fn source(attrs: []const Attribute) Node {
    return dom.tag(.source, attrs, &.{});
}

pub fn track(attrs: []const Attribute) Node {
    return dom.tag(.track, attrs, &.{});
}

pub fn wbr(attrs: []const Attribute) Node {
    return dom.tag(.wbr, attrs, &.{});
}

// Text formatting
pub fn a(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.a, attrs, children);
}

pub fn abbr(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.abbr, attrs, children);
}

pub fn b(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.b, attrs, children);
}

pub fn cite(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.cite, attrs, children);
}

pub fn code(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.code, attrs, children);
}

pub fn del(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.del, attrs, children);
}

pub fn dfn(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.dfn, attrs, children);
}

pub fn em(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.em, attrs, children);
}

pub fn i(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.i, attrs, children);
}

pub fn ins(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.ins, attrs, children);
}

pub fn kbd(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.kbd, attrs, children);
}

pub fn mark(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.mark, attrs, children);
}

pub fn q(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.q, attrs, children);
}

pub fn s(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.s, attrs, children);
}

pub fn samp(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.samp, attrs, children);
}

pub fn small(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.small, attrs, children);
}

pub fn strong(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.strong, attrs, children);
}

pub fn sub(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.sub, attrs, children);
}

pub fn sup(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.sup, attrs, children);
}

pub fn time(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.time, attrs, children);
}

pub fn u(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.u, attrs, children);
}

// var is a reserved word, so we use var_tag
pub fn var_tag(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.var_tag, attrs, children);
}

// Headings and content
pub fn h1(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h1, attrs, children);
}

pub fn h2(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h2, attrs, children);
}

pub fn h3(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h3, attrs, children);
}

pub fn h4(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h4, attrs, children);
}

pub fn h5(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h5, attrs, children);
}

pub fn h6(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.h6, attrs, children);
}

pub fn p(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.p, attrs, children);
}

pub fn pre(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.pre, attrs, children);
}

pub fn blockquote(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.blockquote, attrs, children);
}

// Lists
pub fn dd(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.dd, attrs, children);
}

pub fn dl(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.dl, attrs, children);
}

pub fn dt(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.dt, attrs, children);
}

pub fn li(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.li, attrs, children);
}

pub fn ol(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.ol, attrs, children);
}

pub fn ul(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.ul, attrs, children);
}

// Structure and layout
pub fn address(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.address, attrs, children);
}

pub fn article(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.article, attrs, children);
}

pub fn aside(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.aside, attrs, children);
}

pub fn body(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.body, attrs, children);
}

pub fn div(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.div, attrs, children);
}

pub fn footer(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.footer, attrs, children);
}

pub fn head(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.head, attrs, children);
}

pub fn header(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.header, attrs, children);
}

pub fn hgroup(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.hgroup, attrs, children);
}

pub fn html(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.html, attrs, children);
}

// main is a reserved word, so we use main_tag
pub fn main_tag(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.main, attrs, children);
}

pub fn nav(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.nav, attrs, children);
}

pub fn section(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.section, attrs, children);
}

pub fn span(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.span, attrs, children);
}

// Forms
pub fn button(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.button, attrs, children);
}

pub fn datalist(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.datalist, attrs, children);
}

pub fn fieldset(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.fieldset, attrs, children);
}

pub fn form(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.form, attrs, children);
}

pub fn label(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.label, attrs, children);
}

pub fn legend(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.legend, attrs, children);
}

pub fn meter(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.meter, attrs, children);
}

pub fn optgroup(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.optgroup, attrs, children);
}

pub fn option(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.option, attrs, children);
}

pub fn output(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.output, attrs, children);
}

pub fn progress(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.progress, attrs, children);
}

pub fn select(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.select, attrs, children);
}

pub fn textarea(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.textarea, attrs, children);
}

// Tables
pub fn caption(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.caption, attrs, children);
}

pub fn colgroup(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.colgroup, attrs, children);
}

pub fn table(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.table, attrs, children);
}

pub fn tbody(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.tbody, attrs, children);
}

pub fn td(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.td, attrs, children);
}

pub fn tfoot(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.tfoot, attrs, children);
}

pub fn th(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.th, attrs, children);
}

pub fn thead(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.thead, attrs, children);
}

pub fn tr(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.tr, attrs, children);
}

// Media and embedded content
pub fn audio(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.audio, attrs, children);
}

pub fn canvas(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.canvas, attrs, children);
}

pub fn figure(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.figure, attrs, children);
}

pub fn figcaption(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.figcaption, attrs, children);
}

pub fn iframe(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.iframe, attrs, children);
}

pub fn map(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.map, attrs, children);
}

pub fn object(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.object, attrs, children);
}

pub fn picture(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.picture, attrs, children);
}

pub fn svg(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.svg, attrs, children);
}

pub fn video(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.video, attrs, children);
}

// Other elements
pub fn data(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.data, attrs, children);
}

pub fn details(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.details, attrs, children);
}

pub fn dialog(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.dialog, attrs, children);
}

pub fn menu(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.menu, attrs, children);
}

pub fn noscript(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.noscript, attrs, children);
}

pub fn rp(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.rp, attrs, children);
}

pub fn rt(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.rt, attrs, children);
}

pub fn ruby(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.ruby, attrs, children);
}

pub fn script(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.script, attrs, children);
}

pub fn style(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.style, attrs, children);
}

pub fn summary(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.summary, attrs, children);
}

pub fn template(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.template, attrs, children);
}

pub fn title(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.title, attrs, children);
}

// SVG elements
pub fn circle(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.circle, attrs, children);
}

pub fn clipPath(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.clipPath, attrs, children);
}

pub fn defs(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.defs, attrs, children);
}

pub fn ellipse(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.ellipse, attrs, children);
}

pub fn g(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.g, attrs, children);
}

pub fn line(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.line, attrs, children);
}

pub fn linearGradient(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.linearGradient, attrs, children);
}

pub fn mask(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.mask, attrs, children);
}

pub fn path(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.path, attrs, children);
}

pub fn pattern(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.pattern, attrs, children);
}

pub fn polygon(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.polygon, attrs, children);
}

pub fn polyline(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.polyline, attrs, children);
}

pub fn radialGradient(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.radialGradient, attrs, children);
}

pub fn rect(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.rect, attrs, children);
}

pub fn stop(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.stop, attrs, children);
}

pub fn symbol(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.symbol, attrs, children);
}

pub fn use(attrs: []const Attribute, children: []const Node) Node {
    return dom.tag(.use, attrs, children);
}

// Tests
const testing = std.testing;

test "tags module basic usage" {
    const allocator = testing.allocator;

    // Test basic element creation
    const page = html(&.{}, &.{
        head(&.{}, &.{
            title(&.{}, &.{
                text("Test Page"),
            }),
        }),
        body(&.{}, &.{
            div(&.{attr("class", "container")}, &.{
                h1(&.{}, &.{
                    text("Hello"),
                }),
                p(&.{}, &.{
                    text("World"),
                }),
            }),
        }),
    });

    const html_str = try page.renderToString(allocator);
    defer allocator.free(html_str);

    try testing.expectEqualStrings("<html><head><title>Test Page</title></head><body><div class=\"container\"><h1>Hello</h1><p>World</p></div></body></html>", html_str);
}

test "void elements" {
    const allocator = testing.allocator;

    const content = div(&.{}, &.{
        img(&.{
            attr("src", "test.jpg"),
            attr("alt", "Test"),
        }),
        br(&.{}),
        hr(&.{}),
    });

    const html_str = try content.renderToString(allocator);
    defer allocator.free(html_str);

    try testing.expectEqualStrings("<div><img src=\"test.jpg\" alt=\"Test\"><br><hr></div>", html_str);
}

test "reserved word tags" {
    const allocator = testing.allocator;

    // Test main_tag and var_tag
    const content = main_tag(&.{attr("class", "content")}, &.{
        p(&.{}, &.{
            text("The value is: "),
            var_tag(&.{}, &.{
                text("x"),
            }),
        }),
    });

    const html_str = try content.renderToString(allocator);
    defer allocator.free(html_str);

    try testing.expectEqualStrings("<main class=\"content\"><p>The value is: <var>x</var></p></main>", html_str);
}
