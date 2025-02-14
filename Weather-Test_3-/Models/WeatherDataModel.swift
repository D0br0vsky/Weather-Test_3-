// MARK: - DTO Weather Model
struct WeatherResponse: Codable {
    let list: [WeatherEntry]
    let city: CityInfo
}

struct WeatherEntry: Codable {
    let dateTime: String
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
    let clouds: Clouds
    let visibility: Int?
    let pop: Double?
    let snow: Precipitation?
    let rain: Precipitation?

    enum CodingKeys: String, CodingKey {
        case dateTime = "dt_txt"
        case main, weather, wind, clouds, visibility, pop, snow, rain
    }
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct WeatherCondition: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Precipitation: Codable {
    let threeHourVolume: Double?

    enum CodingKeys: String, CodingKey {
        case threeHourVolume = "3h"
    }
}

struct CityInfo: Codable {
    let name: String
    let country: String
    let timezone: Int
}

// MARK: - DTO City Model
struct CityResponse: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
