// Sendable-1
// Actor boundaries

import Module

#if swift(<6.0)
// From Swift 6.0, a non-Sendable variable cannot be passed to other actors.
private actor Database {
    func save(_ object: NonSendableClass) { /* Save object */ }
}

private struct Repository {
    let database = Database()

    func doSomething(_ nonSendable: NonSendableClass) async {
        // This function is not isolated to any actors,
        // but passes a non-Sendable variable to another actor (Database).
        // A non-Sendable variable cannot cross an actor boundary.
        await database.save(nonSendable)
    }
}
#else
// MARK: - Solution 1 (Recommended)

// A variable needs to be Sendable to cross an actor boundary
private actor Database1 {
    func save(_ object: SendableStruct) { /* Save object */ }
}

private struct Repository1 {
    let database = Database1()

    func save(_ sendable: SendableStruct) async {
        // A sendable can be passed to an actor.
        await database.save(sendable)
    }
}

// MARK: - Solution 2

// As another solution, attaching `sending` is also options.
private actor Database2 {
    func save(_ object: NonSendableClass) { /* Save object */ }
}

private struct Repository2 {
    let database = Database2()

    func save(_ nonSendable: sending NonSendableClass) async {
        // A sendable can be passed to an actor.
        await database.save(nonSendable)
    }
}

// However, you cannot access the variable after passing the argument.
// So, the situation where this solution is available is very limited.
private func doSomething_1() async {
    let nonSendable = NonSendableClass()
    let repository = Repository2()
    await repository.save(nonSendable)
    // 🚨 This makes a compile error.
    // nonSendable.doSomething()
}
#endif
