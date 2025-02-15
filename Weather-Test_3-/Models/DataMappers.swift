protocol DataMappersProtocol: AnyObject {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel
}

final class DataMappers: DataMappersProtocol {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel {
        // Берём первые 5 элементов (или сколько нужно)
        let firstFiveEntries = Array(weather.list.prefix(5))
        
        // Мапим каждый элемент в WeatherInfo
        let weatherInfos: [WeatherInfo] = firstFiveEntries.map { entry in
            let formattedWeekday = DateFormatterHelper.shared.formatToWeekday(from: entry.dateTime)
            
            // roundedInt() — это твой экстеншен или метод для Double,
            // который делает Int. Если у тебя там nil, не забудь обработать.
            let temp = entry.main.temp.roundedInt()
            let tempMin = entry.main.tempMin.roundedInt()
            let tempMax = entry.main.tempMax.roundedInt()
            
            let iconModel = WeatherIconModels(rawValue: entry.weather.first?.icon ?? "") ?? .clearSkyDay
            
            return WeatherInfo(
                temp: "\(temp)°",
                description: entry.weather.first?.description ?? "no data",
                dateTime: formattedWeekday,
                tempMin: "\(tempMin)°",
                tempMax: "\(tempMax)°",
                icon: iconModel
            )
        }
        
        // Обрати внимание, что CityWeatherModel теперь должен хранить массив weatherList
        return CityWeatherModel(
            name: city.name,
            country: city.country.countryName,
            weatherList: weatherInfos
        )
    }

}
