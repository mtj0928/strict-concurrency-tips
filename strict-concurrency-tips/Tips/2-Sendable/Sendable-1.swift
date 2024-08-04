// Sendable-1
// Actor boundaries

import Module

#if swift(<6.0)
// From Swift 6.0, a non-Sendable variable cannot be passed to other actors.
private actor FooActor {
    func doSomething(_ object: NonSendableClass) { /* ... */ }
}

private struct Foo {
    let fooActor = FooActor()

    func doSomething(_ nonSendable: NonSendableClass) async {
        // This function is not isolated to any actors,
        // but passes a non-Sendable variable to another actor.
        // A non-Sendable variable cannot cross an actor boundary.
        await fooActor.doSomething(nonSendable)
    }
}
#else
// MARK: - Solution 1 (Recommended)

// A variable needs to be Sendable to cross an actor boundary
private actor FooActor {
    func doSomething(_ object: SendableStruct) { /* ... */ }
}

private struct Foo {
    let fooActor = FooActor()

    func doSomething(_ sendable: SendableStruct) async {
        // A sendable can be passed to an actor.
        await fooActor.doSomething(sendable)
    }
}

// MARK: - Solution 2

// As another solution, attaching `sending` is also options.
private actor FooActor2 {
    func doSomething(_ object: NonSendableClass) { /* ... */ }
}

private struct Foo2 {
    let fooActor = FooActor2()

    func doSomething(_ nonSendable: sending NonSendableClass) async {
        // A sendable can be passed to an actor.
        await fooActor.doSomething(nonSendable)
    }
}

// However, you cannot access the variable after passing the argument.
// So, the situation where this solution is available is very limited.
private func doSomething() async {
    let nonSendable = NonSendableClass()
    await Foo2().doSomething(nonSendable)
    // 🚨 This makes a compile error.
    // nonSendable.doSomething()
}
#endif
