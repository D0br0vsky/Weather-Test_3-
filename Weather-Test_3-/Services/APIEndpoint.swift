import Foundation

protocol APIEndpointProtocol {
    func makeRequestFindCity(cityName: String) -> URLRequest?
    func makeRequestFindWeather(lat: Double, lon: Double) -> URLRequest?
}

struct APIEndpoint: APIEndpointProtocol {
    private let baseURL = "https://api.openweathermap.org"
    private var apiKey: String { return Bundle.main.apiKey }
    
    func makeRequestFindCity(cityName: String) -> URLRequest? {
        let path = "/geo/1.0/direct"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "limit", value: "4"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return createRequest(path: path, queryItems: queryItems)
    }
    
    func makeRequestFindWeather(lat: Double, lon: Double) -> URLRequest? {
        let path = "/data/2.5/forecast"
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        return createRequest(path: path, queryItems: queryItems)
    }
}

// MARK: - Private Methods
private extension APIEndpoint {
    private func createRequest(path: String, queryItems: [URLQueryItem]) -> URLRequest? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}
