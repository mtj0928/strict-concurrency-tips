# StrictConcurrency Tips
This repository shows tips of Swift 6 migrations

## Environment
This project requires Xcode 16 (beta 4+) and iOS simulator.

## Build Schemes
The project has three build schemes.
- Swift 5
- Swift 5 + StrictConcurrency
- Swift 6

By swiftching the build scheme, you can experience the differences of build settings.

<img width="327" alt="scheme" src="https://github.com/user-attachments/assets/6c2d0af6-1ed4-45be-99b1-2383dc8052d4">


## How to Switch Code
You can use compiler macros like these
```swift
#if swift(<6.0)
// Swift 5 and Swift5 + StrictConcurrency are here.
#else
// Swift 6 is here.
#endif
```

```swift
#if hasFeature(StrictConcurrency)
// Swift5 + StrictConcurrency and Swift 6 are here.
#else
// Swift 5 is here.
#endif
```

This tables shows the values of the compiler macros for each target.

|| `swift(<6.0)` | `hasFeature(StrictConcurrency)` |
| ---- | --- | --- |
| Swift 5 | false | fase |
| Swift 5 + StrictConcurrency | false | true |
| Swift 6 | true | true |
