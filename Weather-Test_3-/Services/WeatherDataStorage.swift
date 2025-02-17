import Foundation

protocol WeatherDataStorageProtocol {
    func getWeatherData() -> [CityWeatherModel]
    func loadingWeatherData(_ query: String, completion: @escaping (Result<[CityWeatherModel], Error>) -> Void)
}

final class WeatherDataStorage: WeatherDataStorageProtocol {
    private let dataService: DataServiceProtocol
    private var cachedData: [CityWeatherModel] = []
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func getWeatherData() -> [CityWeatherModel] {
        return cachedData
    }
    
    func loadingWeatherData(_ query: String, completion: @escaping (Result<[CityWeatherModel], Error>) -> Void) {
        dataService.fetchCityWeatherList(query: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let weatherModels):
                self.cachedData = weatherModels
                completion(.success(cachedData))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
