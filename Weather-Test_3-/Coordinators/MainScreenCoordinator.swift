final class MainScreenCoordinator: Coordinator {
    var customNavigationController: CustomNavigationController
    
    init(customNavigationController: CustomNavigationController) {
        self.customNavigationController = customNavigationController
    }
    
    func start() {
        let mainScreen = MainScreenFactory().make(coordinator: self)
        customNavigationController.pushViewController(mainScreen, animated: true)
    }
    
    func showWeatherScreen(for cityModel: MainScreenViewCell.Model) {
        let weatherScreen = WeatherScreenFactory().make(city: cityModel)
        weatherScreen.modalPresentationStyle = .pageSheet
        weatherScreen.modalTransitionStyle = .coverVertical
        
        if let sheet = weatherScreen.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
        }
        
        customNavigationController.present(weatherScreen, animated: true)
    }
}
