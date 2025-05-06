# `stdout.s`

The `@GOTPAGE` and `@GOTPAGEOFF` are macOS-specific relocations used for Position Independent Code (PIC) when accessing global data through the Global Offset Table (GOT).

Here's what they do:

1. `@GOTPAGE`: Gets the page address of the entry in the GOT that contains the address of `message`
2. `@GOTPAGEOFF`: Gets the offset within that page to the exact GOT entry

This two-step process is needed because:
- The actual address of `message` isn't known until runtime
- macOS requires all code to be position-independent
- The GOT contains the actual runtime addresses of all global data

It's similar to this pseudocode:
```c
// Get page containing GOT entry for message
page_address = &GOT[message] & ~0xFFF;  // @GOTPAGE

// Get exact address by adding offset within page
actual_address = *(&GOT[message] + offset);  // @GOTPAGEOFF
```

In the assembly:
```arm64
adrp x1, message@GOTPAGE    // x1 = page containing GOT entry
ldr x1, [x1, message@GOTPAGEOFF] // x1 = actual address of message
```

This indirection through the GOT allows the code to be loaded at any address and still work correctly, which is a requirement for macOS's dynamic linking.