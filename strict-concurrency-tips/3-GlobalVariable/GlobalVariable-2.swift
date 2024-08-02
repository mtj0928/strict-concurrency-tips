// GlobalVariable-2
// GlobalVariable + Non-Sendable

import Foundation
import Module

#if swift(<6.0)
private enum Foo {
    // This global variable can be accessed from any threads, and it can make a data race.
    static var nonSendableValue = NonSendableClass()
}

private func doSomething() {
    DispatchQueue.global().async {
        // The function can be called from a background thread.
        Foo.nonSendableValue.doSomething()
    }
    Task {
        // The function can be called from a non-isolated context.
        Foo.nonSendableValue.doSomething()
    }
    Task { @MainActor in
        // The function can be called from MainActor.
        Foo.nonSendableValue.doSomething()
    }
}
#else
// MARK: - Solution 1 | Isolate the variable to an actor.

private enum Foo {
    // The cause is the global variable can be accessed from any threads and actors.
    // To prevent the issue, isolating the global variable is one of solutions.
    @MainActor
    static var nonSendableValue1 = NonSendableClass()
}

private func doSomething1() {
    DispatchQueue.main.async {
        // DispatchQueue.main.async isolates the closure to MainActor.
        let nonSendableValue = Foo.nonSendableValue1
        nonSendableValue.doSomething()
    }
    Task { @MainActor in
        let nonSendableValue = Foo.nonSendableValue1
        nonSendableValue.doSomething()
    }

    // You cannot call the function from others.
    DispatchQueue.global().async {
        // 🚨 This makes a compile error.
        // let nonSendableValue = Foo.nonSendableValue1
        // nonSendableValue.doSomething()
    }
    Task {
        // 🚨 This makes a compile error, because the instance cannot be shared between MainActor and non-isolated context.
        // let nonSendableValue = await Foo.nonSendableValue1
        // nonSendableValue.doSomething()
    }
}

// MARK: - Solution 2 | Computed property
extension Foo {
    // If you can accept that the instance is made for each time.
    // You can make it a computed property
    static var nonSendableValue2: NonSendableClass {
        NonSendableClass()
    }
}

private func doSomething2() {
    DispatchQueue.main.async {
        // DispatchQueue.main.async isolates the closure to MainActor.
        let nonSendableValue = Foo.nonSendableValue2
        nonSendableValue.doSomething()
    }
    Task { @MainActor in
        let nonSendableValue = Foo.nonSendableValue2
        nonSendableValue.doSomething()
    }

    DispatchQueue.global().async {
         let nonSendableValue = Foo.nonSendableValue2
         nonSendableValue.doSomething()
    }
    Task {
         let nonSendableValue = Foo.nonSendableValue2
         nonSendableValue.doSomething()
    }
}

// MARK: - Solution 3 | nonisolated(unsafe)

extension Foo {
    // The cause is the global variable can be accessed from any threads and actors.
    // To prevent the issue, isolating the global variable is one of solutions.
    nonisolated(unsafe) static var nonSendableValue3 = NonSendableClass()
}

extension NSLock {
    static let nonSendableValue3 = NSLock()
}

private func doSomething3_1() {
    let value = NSLock.nonSendableValue3.withLock {
        Foo.nonSendableValue3.value += 1
        return Foo.nonSendableValue3.value
    }
    print(value)
}

// However this solution is unsafer than a case where the type is Sendable,
// because not only the global variable but also the instance itself need to be accessed from only a specific thread.
// This is an example of bad pattern
private func doSomething3_2() {
    DispatchQueue.global().async {
        let nonSendableValue = NSLock.nonSendableValue3.withLock {
            // Protecting an access to the global variable (not enough)
            return Foo.nonSendableValue3
        }
        nonSendableValue.value += 1 // 🚨 The value is updated from the background thread
    }

    DispatchQueue.main.async {
        let nonSendableValue = NSLock.nonSendableValue3.withLock {
            // Protecting an access to the global variable (not enough)
            return Foo.nonSendableValue3
        }
        nonSendableValue.value += 1 // 🚨 The value is updated from the main thread
    }
}
#endif
