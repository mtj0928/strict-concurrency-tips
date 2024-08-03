# StrictConcurrency Tips
A place where you can experience the differences of concurrency checking with the same same source file and learn the tips.

## Environment
This project requires Xcode 16 (beta 4 or later) and iOS simulator.

## Usage
Clone this repository and open the xcworkspace.
```sh
git clone https://github.com/mtj0928/strict-concurrency-tips
cd strict-concurrency-tips
open strict-concurrency-tips.xcworkspace
```

## Contents
This repository has two contents.
- Playground
- Tips

### Playground
[Playground](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Playground.swift) is a place you you can experience the differences with the same swift file.

For more details, please check [Build Schemes](#build-schemes) and [How to Switch Code](#how-to-switch-code)

### Tips
This repository also shows tips for strict concurrency checking.
By switching the build scheme, you can learn the tips with actual compile checks.

#### Index
1. MainActor
    - [UIView/UIViewController case](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/1-MainActor/MainActor-1.swift)
    - [Preconcurrency isolation](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/1-MainActor/MainActor-2.swift)
    - [Preconcurrency conformance / MainActor.assumeIsolated](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/1-MainActor/MainActor-3.swift)
2. Sendable
    - [Actor boundaries](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/2-Sendable/Sendable-1.swift)
    - [Mutable class + Sendable](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/2-Sendable/Sendable-2.swift)
    - [preconcurrency import](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/2-Sendable/Sendable-3.swift)
3. GlobalVariable
    - [GlobalVariable + Sendable](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/3-GlobalVariable/GlobalVariable-1.swift)
    - [GlobalVariable + Non-Sendable](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/3-GlobalVariable/GlobalVariable-2.swift)
4. Others
    - [deinit](https://github.com/mtj0928/strict-concurrency-tips/blob/main/strict-concurrency-tips/Tips/4-Others/deinit-1.swift)
    
If you want more contents, feel free to make a new issue with an error or warning example.

## Build Schemes
The project has three build schemes.
- Swift 5
- Swift 5 + StrictConcurrency
- Swift 6

By switching the build scheme, you can experience the differences of the build settings.

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

## Reference
[The Swift Concurrency Migration Guide](https://www.swift.org/migration/documentation/migrationguide) is the official migration guide.
The contents are updated daily, and they are the most reliable informations.
This repository also refer the guideline.
