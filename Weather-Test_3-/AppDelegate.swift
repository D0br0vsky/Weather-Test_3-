//  Created by Dobrovsky on 10.02.2025.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let customNavigationController = CustomNavigationController()
        appCoordinator = AppCoordinator(customNavigationController: customNavigationController)
        appCoordinator?.start()
        
        window?.rootViewController = customNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
