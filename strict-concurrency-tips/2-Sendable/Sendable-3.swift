// Sendable-3
// preconcurrency import

#if swift(<6.0)
import Module

// Consider a case where a type in another module is not Sendable but thread safe.
private func doSomething() {
    let nonSendable = NonSendableButThreadSafe()
    Task {
        nonSendable.doSomething()
    }
    nonSendable.doSomething()
}
#else
// @preconcurrency import is useful for such situation.
// This import will be pointed out when `NonSendableButThreadSafe` becomes thread safe.
@preconcurrency import Module

private func doSomething() {
    let nonSendable = NonSendableButThreadSafe()
    Task {
        // This code is still pointed out, but it is warning.
        nonSendable.doSomething()
    }
    nonSendable.doSomething()
}
#endif
