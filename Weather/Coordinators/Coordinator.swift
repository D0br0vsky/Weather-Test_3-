import UIKit

protocol Coordinator: AnyObject {
    var customNavigationController: CustomNavigationController { get set }
    func start()
}
