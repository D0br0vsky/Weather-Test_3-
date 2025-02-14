protocol DataMappersProtocol: AnyObject {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel
}

final class DataMappers: DataMappersProtocol {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel {
        let firstEntry = weather.list.first
        
        let formattedWeekday = DateFormatterHelper.shared.formatToWeekday(from: firstEntry?.dateTime ?? "")
        
        let temp = firstEntry?.main.temp.roundedInt() ?? 0
        let tempMin = firstEntry?.main.tempMin.roundedInt() ?? 0
        let tempMax = firstEntry?.main.tempMax.roundedInt() ?? 0
        
        let iconModel = WeatherIconModels(rawValue: firstEntry?.weather.first?.icon ?? "") ?? .clearSkyDay
        
        let weatherInfo = WeatherInfo(
            temp: "\(temp)°",
            description: firstEntry?.weather.first?.description ?? "Нет данных",
            dateTime: "\(formattedWeekday)",
            tempMin: "\(tempMin)°",
            tempMax: "\(tempMax)°",
            icon: iconModel
        )
        
        return CityWeatherModel(
            name: city.name,
            country: city.country.countryName,
            weather: weatherInfo
        )
    }
}
