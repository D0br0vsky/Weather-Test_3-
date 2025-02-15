struct CityWeatherModel {
    let name: String
    let country: String
    let weatherList: [WeatherInfo]
}

struct WeatherInfo {
    let temp: String
    let description: String
    let dateTime: String
    let tempMin: String
    let tempMax: String
    let icon: WeatherIconModels
}
