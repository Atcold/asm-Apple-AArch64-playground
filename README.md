# Apple AArch64 playground

A collection of minimal assembly programs for macOS on Apple Silicon (AArch64).
This repository is meant for experimentation, learning, and low-level exploration of the Apple ARM64 architecture.


## 🧰 Requirements

- macOS (Apple Silicon)
- `clang` (Apple LLVM)
- Optional: `lldb` for debugging

## 📂 Structure

Each `.s` file is a standalone assembly program, assembled and linked with `clang`.

```
src/
├── hello.c              # print "Hello" to screen
├── mul.c                # print multiplication output to screen
├── minimal.s            # return to the OS the multiplication of two numbers
annotation/
├── mul_commented.s      # clean up compiled `mul.c`
```

## 🛠️ Building

You can compile with:

```sh
clang -S hello.c
```

You can assemble and run with:

```sh
clang -o hello hello.s
./hello
```

You can compile an x86_64 version (runs under Rosetta) with:

```
clang -arch x86_64 -S -o hello_x86_64.s hello.c
```

To assemble an x86_64 version type:

```sh
clang -arch x86_64 -o hello_x86_64 hello_x86_64.s
./hello_x86_64
```


## 📚 References

- [Apple ARM64 ABI Documentation](https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms)
- [ARMv8 AArch64/ARM64 Full Beginner's Assembly Tutorial](https://mariokartwii.com/armv8/)
