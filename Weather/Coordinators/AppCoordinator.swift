import UIKit

final class AppCoordinator: Coordinator {
    var customNavigationController: CustomNavigationController
    
    init(customNavigationController: CustomNavigationController) {
        self.customNavigationController = customNavigationController
    }
    
    func start() {
        showMainScreen()
    }
    
    private func showMainScreen() {
        let mainScreenCoordinator = MainScreenCoordinator(customNavigationController: customNavigationController)
        mainScreenCoordinator.start()
    }
}
