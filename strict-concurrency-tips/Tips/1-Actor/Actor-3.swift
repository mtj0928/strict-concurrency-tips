// Actor-3
// Preconcurrency conformance / MainActor.assumeIsolated

import Module

#if swift(<6.0)
// If a protocol in another module doesn't require `MainActor`
// even though the function is always called in the main thread,
// the function is pointed out on Swift 5 + StrictConcurrency.
@MainActor
private final class FooViewController: FooViewDelegate {
    public func didTapFooView(_ fooView: FooView) {
        // Do something
    }
}
#else
// MARK: - Solution 1

// If you use Swift 6, preconcurrency conformance is useful.
// This suppresses warnings about an actor mismatch.
@MainActor
private final class FooViewController: @preconcurrency FooViewDelegate {
    public func didTapFooView(_ fooView: FooView) {
        // Do something
    }
}

// MARK: - Solution 2

// As another solution, you can use nonisolated + MainActor.assumeIsolate,
// if the function is always called in the main thread.
@MainActor
private final class FooViewController2: FooViewDelegate {
    public nonisolated func didTapFooView(_ fooView: FooView) {
        // This function is longer isolated to MainActor.
        MainActor.assumeIsolated {
            // MainActor.assumeIsolated switches the actor context to MainActor
            // by assuming the current thread is the main thread.
            //
            // Note that the function makes a crash when the calling thread is not the main thread.
        }
    }
}
#endif
