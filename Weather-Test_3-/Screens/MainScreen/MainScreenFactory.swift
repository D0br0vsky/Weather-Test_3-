import UIKit

final class MainScreenFactory {
    func make(coordinator: MainScreenCoordinator) -> MainScreenViewController {
        let dataLoader = DataLoader()
        let dataDecoder = DataDecoder()
        let dataMappers = DataMappers()
        let dataService = DataService(dataLoader: dataLoader, dataDecoder: dataDecoder, dataMapper: dataMappers)
        let weatherDataStorage = WeatherDataStorage(dataService: dataService)
        let presenter = MainScreenPresenter(coordinator: coordinator, dataLoader: dataLoader, dataService: dataService, weatherDataStorage: weatherDataStorage)
        let viewController = MainScreenViewController(presenter: presenter)
        return viewController
    }
}
