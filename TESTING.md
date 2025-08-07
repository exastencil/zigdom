# ZigDOM Testing Documentation

## Overview

The ZigDOM library includes comprehensive test coverage for recreating HTML
fragments found in the `examples/` directory. The tests demonstrate how to use
the library to build complex HTML structures programmatically.

## Test Structure

### Tailblocks

- Test file: `src/tailblocks.zig`
- Example HTML files: `examples/tailblocks/**/*.html`
- Source: <https://tailblocks.cc> by [Mert Cukuren](https://mert.dev/)

### Testing Approach

Instead of requiring exact HTML string matching (which would be fragile due to
formatting differences), the tests use **structural validation**. This approach:

1. Loads the expected HTML file for reference
2. Recreates the structure using ZigDOM
3. Validates that key structural elements are present in the rendered output
4. Confirms all important content (text, attributes, classes) exists

This makes tests more maintainable and focuses on functional correctness rather than exact formatting.

## Running Tests

```bash
# Run all tests
zig build test

# Run with verbose output
zig build test --verbose
```

## Example Test Pattern

```zig
test "blog layout 1 - 3 column grid with cards" {
    const allocator = testing.allocator;

    // Load expected HTML for reference
    const expected_file = try std.fs.cwd().openFile("examples/tailblocks/blog/1.html", .{});
    defer expected_file.close();
    const expected_html = try expected_file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(expected_html);

    // Create layout using zigdom
    const layout = try createBlogLayout1(allocator);
    defer layout.deinit();

    const actual_html = try layout.renderToString(allocator);
    defer allocator.free(actual_html);

    // Validate structure
    try testing.expect(std.mem.indexOf(u8, actual_html, "text-gray-400 bg-gray-900 body-font") != null);
    try testing.expect(std.mem.indexOf(u8, actual_html, "The Catalyzer") != null);
    // ... more validations
}
```

## Benefits

1. **Documentation by Example**: Tests serve as living documentation showing how to use the library
2. **Reusable Components**: Helper functions demonstrate component composition patterns
3. **Regression Prevention**: Tests ensure library changes don't break existing functionality
4. **Real-World Usage**: Tests use actual HTML from Tailwind UI blocks, representing real use cases

## Adding New Tests

To add tests for new HTML examples:

1. Place the HTML file in `examples/` directory
2. Create a builder function that recreates the structure using ZigDOM
3. Add a test that loads the file and validates the structure
4. Use helper functions for common patterns to reduce duplication

## Future Improvements

- Add more HTML examples from different sources
- Create higher-level component abstractions
- Add performance benchmarks for large DOM trees
- Implement property-based testing for edge cases
