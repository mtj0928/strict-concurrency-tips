# StrictConcurrency Tips

### How to switch code
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
