// Sendable-2
// Mutable class + Sendable

import os

// When you need to make a mutable class conform Sendable, you need to use lock.
// OSAllocatedUnfairLock which is available from iOS 16 is useful for a such case.
private final class Counter: Sendable {
    private let valueLock = OSAllocatedUnfairLock<Int>(initialState: 0)

    func increment() -> Int {
        let value = valueLock.withLock { value in
            value += 1
            return value
        }
        return value
    }
}
