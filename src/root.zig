//! zigdom - A unified DOM library for Zig
//! 
//! Provides a simple, unified Node-based DOM structure where:
//! - Everything is a Node with attributes and children
//! - Nodes are stack-allocated for efficiency
//! - Tag types are represented as an enum

const std = @import("std");

// Export the DOM module
pub const dom = @import("dom.zig");

// Export the tags module for markup-like syntax
pub const tags = @import("tags.zig");

// Re-export commonly used types for convenience
pub const Node = dom.Node;
pub const Tag = dom.Tag;
pub const Attribute = dom.Attribute;

// Re-export the cleaner syntax helper functions
pub const tag = dom.tag;
pub const text = dom.text;
pub const custom = dom.custom;
pub const attr = dom.attr;

test {
    // Include all tests from submodules
    _ = @import("dom.zig");
    _ = @import("tags.zig");
}
