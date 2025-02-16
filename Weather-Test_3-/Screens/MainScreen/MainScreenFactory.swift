import UIKit

final class MainScreenFactory {
    func make(coordinator: MainScreenCoordinator) -> MainScreenViewController {
        let dataLoader = DataLoader()
        let dataDecoder = DataDecoder()
        let dateFormatterHelperProtocol = DateFormatterHelper()
        let dataMappers = DataMappers(dateFormatterHelperProtocol: dateFormatterHelperProtocol)
        let apiEndpoint = APIEndpoint()
        let videoPlayerManager = VideoPlayerManager()
        let dataService = DataService(dataLoader: dataLoader, dataDecoder: dataDecoder, dataMapper: dataMappers, apiEndpoint: apiEndpoint)
        let weatherDataStorage = WeatherDataStorage(dataService: dataService)
        let presenter = MainScreenPresenter(coordinator: coordinator, weatherDataStorage: weatherDataStorage)
        let viewController = MainScreenViewController(presenter: presenter, videoPlayerManager: videoPlayerManager)
        return viewController
    }
}
