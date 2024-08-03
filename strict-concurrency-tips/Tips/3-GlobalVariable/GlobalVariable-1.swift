// GlobalVariable-1
// GlobalVariable + Sendable

import Foundation
import Module

#if swift(<6.0)
private enum Foo {
    // This global variable can be accessed from any threads, and it can make a data race.
    static var sendableValue = SendableStruct()
}

private func doSomething() {
    DispatchQueue.global().async {
        // The global variable can updated in a background thread.
        Foo.sendableValue = SendableStruct()
    }
    Task {
        // The global variable can updated in non-isolated context.
        Foo.sendableValue = SendableStruct()
    }
    Task { @MainActor in
        // The global variable can updated from MainActor.
        Foo.sendableValue = SendableStruct()
    }
}
#else
// MARK: - Solution 1 | Computed property or let
extension Foo {
    // If you can accept to make an instance for each time,
    // you can make it a computed property.
    static var sendableValue1: SendableStruct {
        SendableStruct()
    }

    // Or, let can also prevent data race.
    static let sendableValue2 = SendableStruct()
}

private func doSomething1() {
    // You can access the global variable anywhere.
    DispatchQueue.main.async {
        Foo.sendableValue1.doSomething()
        Foo.sendableValue2.doSomething()
    }
    Task { @MainActor in
        Foo.sendableValue1.doSomething()
        Foo.sendableValue2.doSomething()
    }

    DispatchQueue.global().async {
        Foo.sendableValue1.doSomething()
        Foo.sendableValue2.doSomething()
    }
    Task {
        Foo.sendableValue1.doSomething()
        Foo.sendableValue2.doSomething()
    }
}
// MARK: - Solution 2 | Isolate the variable to an actor.

private enum Foo {
    // The cause is the global variable can be accessed from any threads and actors.
    // To prevent the issue, isolating the global variable is one of solutions.
    @MainActor
    static var sendableValu3 = SendableStruct()
}

private func doSomething2() {
    DispatchQueue.main.async {
        // DispatchQueue.main.async isolates the closure to MainActor.
        Foo.sendableValu3 = SendableStruct()
    }
    Task { @MainActor in
        Foo.sendableValu3 = SendableStruct()
    }

    // You cannot update the global variable from others.
    DispatchQueue.global().async {
        // 🚨 This makes a compile error.
        // Foo.sendableValu3 = SendableStruct()
    }
    Task {
        // 🚨 This also makes a compile error.
        // Foo.sendableValu3 = SendableStruct()
    }
}

// MARK: - Solution 3 | nonisolated(unsafe)

extension Foo {
    // The cause is the global variable can be accessed from any threads and actors.
    // To prevent the issue, isolating the global variable is one of solutions.
    nonisolated(unsafe) static var sendableValue4 = SendableStruct()
}

extension NSLock {
    static let sendableValue4 = NSLock()
}

private func doSomething3() {
    DispatchQueue.global().async {
        NSLock.sendableValue4.withLock {
            Foo.sendableValue4 = SendableStruct()
        }
    }
    Task {
        NSLock.sendableValue4.withLock {
            Foo.sendableValue4 = SendableStruct()
        }
    }
}
#endif
