struct CityWeatherModel {
    let name: String
    let country: String
    let weatherList: [WeatherInfo]
}

struct WeatherInfo {
    let temp: Int
    let description: String
    let dateTime: String
    let tempMin: Int
    let tempMax: Int
    let icon: WeatherIconModels
}
