@MainActor
public final class FooView {}

public protocol FooViewDelegate {
    /// A delegate function which is called when FooView is tapped.a
    ///
    /// This function is always called in the main thread.
    func didTapFooView(_ fooView: FooView)
}
