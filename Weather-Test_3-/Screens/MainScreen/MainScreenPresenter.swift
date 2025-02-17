import Foundation

protocol MainScreenPresenterProtocol: AnyObject {
    func updateSearchQuery(_ query: String)
    func didSelectWeather(with cityModel: MainScreenViewCell.Model)
}

final class MainScreenPresenter: MainScreenPresenterProtocol {
    var coordinator: MainScreenCoordinator?

    weak var view: MainScreenViewControllerProtocol?
    
    private let debouncer = CancellableExecutor(queue: .main)
    private let weatherDataStorage: WeatherDataStorageProtocol
    private let searchDebouncer: SearchDebouncerProtocol
    
    private var searchQuery: String = ""
    
    init(coordinator: MainScreenCoordinator, weatherDataStorage: WeatherDataStorageProtocol, searchDebouncer: SearchDebouncerProtocol) {
        self.coordinator = coordinator
        self.weatherDataStorage = weatherDataStorage
        self.searchDebouncer = searchDebouncer
    }
    
    func updateSearchQuery(_ query: String) {
        searchQuery = query
        
        searchDebouncer.debounce(query: query) { [weak self] _ in
            self?.loadWeatherData()
        }
    }
    
    func didSelectWeather(with cityModel: MainScreenViewCell.Model) {
        coordinator?.showWeatherScreen(for: cityModel)
    }
    
    func viewDidLoad() {
        view?.setState(.content)
        loadWeatherData()
    }
}

// MARK: - Private Methods
private extension MainScreenPresenter {
    func loadWeatherData() {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            view?.setState(.empty)
            return
        }
        
        weatherDataStorage.loadingWeatherData(trimmedQuery) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.view?.setState(.content)
                    let weatherData = self.weatherDataStorage.getWeatherData()
                    if weatherData.isEmpty {
                        self.view?.setState(.notFound)
                    } else {
                        updateUI()
                    }
                case .failure:
                    self.view?.setState(.notFound)
                }
            }
        }
        
        func updateUI() {
            let videoFileNames = ["previouslyMorning", "day", "morning", "night"]
            
            let items = weatherDataStorage.getWeatherData().enumerated().map { index, city in
                let firstDay = city.weatherList.first
                
                return MainScreenViewCell.Model(
                    name: city.name,
                    country: city.country,
                    dateTime: firstDay?.dateTime ?? "no data",
                    temp: firstDay?.temp ?? 0,
                    description: firstDay?.description ?? "",
                    tempMin: firstDay?.tempMin ?? 0,
                    tempMax: firstDay?.tempMax ?? 0,
                    videoFileName: videoFileNames[index % videoFileNames.count],
                    icon: firstDay?.icon ?? .clearSkyDay,
                    weatherList: city.weatherList
                )
            }
            
            let viewModel = MainScreenView.Model(items: items)
            view?.update(model: viewModel)
        }
    }
}
