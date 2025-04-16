// Actor-4
// Invocation of an async function of non-Sendable in an actor

private actor MyActor {
    let nonSendable = NonSendable()

    func doSomething() async {
#if swift(<6.0)
        // async function of nonSendable cannot be called in an actor.
        await nonSendable.doSomething()
#else
        await nonSendable.doSomethingB()
#endif
    }
}

private final class NonSendable {

    func doSomething() async {
        // ...
    }

    // Use `isolated` attribute and #isolation.
    // `isolated` attribute means the function will run on the given actor.
    // #isolation means an actor of the caller of this function will be filled to the argument as a default value.
    // So, by combining `isolated` and #isolation, the function will run on the same actor with the caller.
    func doSomethingB(actor: isolated (any Actor)? = #isolation) async {
        // ...
    }
}
