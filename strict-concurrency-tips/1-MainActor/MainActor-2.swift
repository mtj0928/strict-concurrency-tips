// MainActor-2
// Preconcurrency isolation

import UIKit

// Let's consider a case where this function is called in other many modules
// and it's hard to attach `@MainActor` to all places.
// `@preconcurrency @MainActor` is a good selection for such a case.
@preconcurrency @MainActor
private func present(_ viewController: UIViewController) {
    let newViewController = UIViewController()
    viewController.present(newViewController, animated: true)
}

#if swift(<6.0)
// present2 can be called in a function which is not isolated to MainActor.
// However, the code is pointed out as a warning when StrictConcurrency is enabled.
private func presentCaller(_ viewController: UIViewController) {
    present(viewController)
}
#else
// In Swift 6, the preconcurrency annotation is meaningless.
// You need to isolate the function invocation to MainActor.
@MainActor
private func presentCaller(_ viewController: UIViewController) {
    present(viewController)
}
#endif
