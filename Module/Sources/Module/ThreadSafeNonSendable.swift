import Foundation

/// This class doesn't conform Sendable, but it is thread safe.
public final class NonSendableButThreadSafe {
    public var value: Int {
        get {
            lock.withLock {
                internalValue
            }
        }
        set {
            lock.withLock {
                internalValue = newValue
            }
        }
    }

    private var internalValue: Int = 10
    private let lock = NSLock()

    public init() {}

    public func doSomething() {}
}
