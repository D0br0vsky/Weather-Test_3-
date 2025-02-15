import Foundation

protocol DataServiceProtocol {
    func fetchCityWeatherList(query: String, completion: @escaping (Result<[CityWeatherModel], Error>) -> Void)
}

final class DataService: DataServiceProtocol {
    private let apiEndpoint = APIEndpoint()
    private let dataLoader: DataLoaderProtocol
    private let dataDecoder: DataDecoderProtocol
    private let dataMapper: DataMappersProtocol
    
    init(dataLoader: DataLoaderProtocol, dataDecoder: DataDecoderProtocol, dataMapper: DataMappersProtocol) {
        self.dataLoader = dataLoader
        self.dataDecoder = dataDecoder
        self.dataMapper = dataMapper
    }
    
    func fetchCityWeatherList(query: String, completion: @escaping (Result<[CityWeatherModel], Error>) -> Void) {
        fetchCity(query: query) { [weak self] cityResult in
            guard let self = self else { return }
            
            switch cityResult {
            case .success(let cities):
                guard !cities.isEmpty else {
                    completion(.failure(NSError(domain: "No cities found", code: 404)))
                    return
                }

                let dispatchGroup = DispatchGroup()
                var cityWeatherModels: [CityWeatherModel] = []
                var loadError: Error?

                for city in cities {
                    dispatchGroup.enter()
                    self.fetchWeather(lat: city.lat, lon: city.lon) { weatherResult in
                        switch weatherResult {
                        case .success(let weather):
                            let model = self.dataMapper.mapToDomainModel(city: city, weather: weather)
                            cityWeatherModels.append(model)
                        case .failure(let error):
                            loadError = error
                        }
                        dispatchGroup.leave()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    if let error = loadError {
                        completion(.failure(error))
                    } else {
                        completion(.success(cityWeatherModels))
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

// MARK: - Private Methods
private extension DataService {
    func fetchCity(query: String, completion: @escaping (Result<[CityResponse], Error>) -> Void) {
        guard let request = apiEndpoint.makeRequestFindCity(cityName: query) else {
            completion(.failure(NSError(domain: "Invalid request", code: 2)))
            return
        }

        dataLoader.fetchData(url: request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let data):
                let decodedResult: Result<[CityResponse], Error> = self.dataDecoder.decode(data)
                completion(decodedResult)
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        guard let request = apiEndpoint.makeRequestFindWeather(lat: lat, lon: lon) else {
            completion(.failure(NSError(domain: "Invalid request", code: 3)))
            return
        }
        
        dataLoader.fetchData(url: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let decodedResult: Result<WeatherResponse, Error> = dataDecoder.decode(data)
                completion(decodedResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
