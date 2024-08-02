// MainActor-1
// UIView/UIViewController case
import UIKit

#if swift(<6.0)
// Views like `UIViewController` and `UIView` are isolated to MainActor from Swift 6.
private func present_1(_ viewController: UIViewController) {
    let newViewController = UIViewController()
    viewController.present(newViewController, animated: true)
}
#else
// You need to isolate a function which touches such classes from Swift 6.
@MainActor
private func present_1(_ viewController: UIViewController) {
    let newViewController = UIViewController()
    viewController.present(newViewController, animated: true)
}
#endif
