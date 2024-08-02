// deinit-1
// deinit + Non-Sendable

private final class NonSendableObserver {
    func stop() {}
}

#if swift(<6.0)
// Let's consider a situation where a class isolated to MainActor, observes something
// and it will need to be stopped in deinit.
@MainActor private class Foo {
    private var nonSendableObserver: NonSendableObserver?

    deinit {
        // This code is pointed out in strict concurrency checking mode,
        // because deinit is not isolated to any actors, but the code accesses to self in MainActor.
        nonSendableObserver?.stop()
    }

    func stop() {}
}
#else
// Only sendable variable can be accessed in the deinit.
// Therefore, a wrapper isolating the non-Sendable type can resolve the issue.
@MainActor
private final class MainActorObserver {
    var internalObserver: NonSendableObserver?

    func stop() { internalObserver?.stop() }
}

@MainActor private class Foo {
    private var actorObserver: MainActorObserver?

    deinit {
        // ⚠️ Capturing the property directly is necessary in this case.
        Task { [actorObserver] in
            await actorObserver?.stop()
        }

        Task {
            // 🚨 This code crashes.
            // await actorObserver?.stop()

            // Because the code equals the next one and `self` is accessed even it already released.
            // await self.actorObserver?.stop()
        }
    }
}
#endif
