import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func searchUpdate(_ query: String)
    func didSelectWeather(with cityModel: MainScreenViewCell.Model)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    var coordinator: MainScreenCoordinator?

    weak var view: MainScreenViewControllerProtocol?
    
    private let debouncer = CancellableExecutor(queue: .main)
    private let dataLoader: DataLoaderProtocol
    private let dataService: DataServiceProtocol
    private let weatherDataStorage: WeatherDataStorageProtocol
    
    private var searchQuery: String = ""
    
    init(coordinator: MainScreenCoordinator, dataLoader: DataLoaderProtocol, dataService: DataServiceProtocol, weatherDataStorage: WeatherDataStorageProtocol) {
        self.coordinator = coordinator
        self.dataLoader = dataLoader
        self.dataService = dataService
        self.weatherDataStorage = weatherDataStorage
    }
    
    func searchUpdate(_ query: String) {
        searchQuery = query
        
        debouncer.execute(delay: .milliseconds(400)) { [weak self] isCancelled in
            guard let self = self, !isCancelled.isCancelled else { return }
            loadWeatherData()
        }
    }
    
    func didSelectWeather(with cityModel: MainScreenViewCell.Model) {
        coordinator?.showWeatherScreen(for: cityModel)
    }
    
    func viewDidLoad() {
        loadWeatherData()
    }
}

// MARK: - Private Methods
private extension MainScreenPresenter {
    func loadWeatherData() {
        weatherDataStorage.loadingWeatherData(searchQuery) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateUI()
                case .failure(let error):
                    print(error)
                    // потом показать экран с ошибкой поиска
                }
            }
        }
    }
    
    func updateUI() {
        let videoFiles = ["previouslyMorning", "day", "morning", "night"]
        
        let items = weatherDataStorage.getWeatherData().enumerated().map { index, city in
            MainScreenViewCell.Model(
                name: city.name, country: city.country,
                dateTime: city.weather.dateTime,
                temp: city.weather.temp,
                description: city.weather.description,
                tempMin: city.weather.tempMin,
                tempMax: city.weather.tempMax,
                videoFileName: videoFiles[index % videoFiles.count], icon: city.weather.icon
            )
        }
        
        let viewModel = MainScreenView.Model(items: items)
        view?.update(model: viewModel)
    }
}
