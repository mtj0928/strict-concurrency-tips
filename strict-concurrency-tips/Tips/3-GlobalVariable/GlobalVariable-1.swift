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
    DispatchQueue.main.async {
        // The global variable can be read/written in the main thread.
        _ = Foo.sendableValue
        Foo.sendableValue = SendableStruct()
    }
    Task { @MainActor in
        // The global variable can be read/written in MainActor.
        _ = Foo.sendableValue
        Foo.sendableValue = SendableStruct()
    }
    DispatchQueue.global().async {
        // The global variable can be read/written in a background thread.
        _ = Foo.sendableValue
        Foo.sendableValue = SendableStruct()
    }
    Task {
        // The global variable can be read/written in a non-isolated context.
        _ = Foo.sendableValue
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
    static var sendableValue3 = SendableStruct()
}

private func doSomething2() {
    DispatchQueue.main.async {
        // DispatchQueue.main.async isolates the closure to MainActor.
        _ = Foo.sendableValue3
        Foo.sendableValue3 = SendableStruct()
    }
    Task { @MainActor in
        _ = Foo.sendableValue3
        Foo.sendableValue3 = SendableStruct()
    }

    // You cannot update the global variable from others.
    DispatchQueue.global().async {
        // 🚨 These make compile errors.
        // _ = Foo.sendableValu3
        // Foo.sendableValue3 = SendableStruct()
    }
    Task {
        // The value can be read.
        _ = await Foo.sendableValue3
        // 🚨 This also makes a compile error.
        // Foo.sendableValue3 = SendableStruct()
    }
}

// MARK: - Solution 3 | nonisolated(unsafe)

extension Foo {
    nonisolated(unsafe) private static var _sendableValue4 = SendableStruct()
    static let lock = NSLock()

    // `nonisolated(unsafe)` doesn't prevent from data race, we need to address the issue manually by using like lock.
    static var sendableValue4: SendableStruct {
        get {
            lock.withLock { _sendableValue4 }
        }
        set {
            lock.withLock { _sendableValue4 = SendableStruct() }
        }
    }
}

private func doSomething3() {
    DispatchQueue.global().async {
        // The value can be read and written in any contexts
        _ = Foo.sendableValue4
        Foo.sendableValue4 = SendableStruct()
    }
    Task {
        // The value can be read and written in any contexts
        _ = Foo.sendableValue4
        Foo.sendableValue4 = SendableStruct()
    }
}
#endif
