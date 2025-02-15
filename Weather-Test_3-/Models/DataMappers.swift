import Foundation

protocol DataMappersProtocol: AnyObject {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel
}

final class DataMappers: DataMappersProtocol {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel {
        let groupedByDay = Dictionary(grouping: weather.list) { entry in
            DateFormatterHelper.shared.formatYMD(from: DateFormatterHelper.shared.parseDate(from: entry.dateTime) ?? Date())
        }
        
        let sortedDays = groupedByDay.keys.sorted().prefix(5)
        
        let weatherInfos: [WeatherInfo] = sortedDays.compactMap { dayKey in
            guard let entries = groupedByDay[dayKey], let firstEntry = entries.first else {
                return nil
            }
            
            let avgMin = entries.map { $0.main.tempMin }.reduce(0, +) / Double(entries.count)
            let avgMax = entries.map { $0.main.tempMax }.reduce(0, +) / Double(entries.count)
            
            return WeatherInfo(
                temp: "\(firstEntry.main.temp.roundedInt())°",
                description: firstEntry.weather.first?.description ?? "no data",
                dateTime: DateFormatterHelper.shared.formatToWeekday(from: firstEntry.dateTime),
                tempMin: "\(avgMin.roundedInt())°",
                tempMax: "\(avgMax.roundedInt())°",
                icon: WeatherIconModels(rawValue: firstEntry.weather.first?.icon ?? "") ?? .clearSkyDay
            )
        }
        
        return CityWeatherModel(
            name: city.name,
            country: city.country.countryName,
            weatherList: weatherInfos
        )
    }
}
