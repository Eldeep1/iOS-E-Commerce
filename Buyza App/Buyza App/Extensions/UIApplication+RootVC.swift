import UIKit

extension UIApplication {
    func getRootViewController() -> UIViewController {
        guard let screen = connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        return top
    }
}
