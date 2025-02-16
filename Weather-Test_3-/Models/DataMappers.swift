import Foundation

protocol DataMappersProtocol: AnyObject {
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel
}

final class DataMappers: DataMappersProtocol {
    private let dateFormatterHelperProtocol: DateFormatterHelperProtocol
    
    init(dateFormatterHelperProtocol: DateFormatterHelperProtocol) {
        self.dateFormatterHelperProtocol = dateFormatterHelperProtocol
    }
    
    func mapToDomainModel(city: CityResponse, weather: WeatherResponse) -> CityWeatherModel {
        let groupedByDay = Dictionary(grouping: weather.list) { entry in
            let date = dateFormatterHelperProtocol.parseDate(from: entry.dateTime) ?? Date()
            return dateFormatterHelperProtocol.formatYMD(from: date)
        }
        
        let sortedDays = groupedByDay.keys.sorted().prefix(5)
        
        let weatherInfos: [WeatherInfo] = sortedDays.compactMap { dayKey in
            guard let dayEntries = groupedByDay[dayKey], !dayEntries.isEmpty else {
                return nil
            }
            
            let dailyMin = dayEntries.compactMap { $0.main.tempMin }.min() ?? 0.0
            let dailyMax = dayEntries.compactMap { $0.main.tempMax }.max() ?? 0.0
            
            let threeAMEntry = dayEntries.first { entry in
                guard let date = dateFormatterHelperProtocol.parseDate(from: entry.dateTime) else { return false }
                let hour = Calendar.current.component(.hour, from: date)
                return hour == 3
            }
            
            let usedEntry = threeAMEntry ?? dayEntries.first!
            
            let currentTemp = usedEntry.main.temp.roundedInt()
            let description = usedEntry.weather.first?.description ?? "no data"
            let iconCode = usedEntry.weather.first?.icon ?? ""
            
            return WeatherInfo(
                temp: "\(currentTemp)°",
                description: description,
                dateTime: dateFormatterHelperProtocol.formatToWeekday(from: usedEntry.dateTime),
                tempMin: "\(dailyMin.roundedInt())°",
                tempMax: "\(dailyMax.roundedInt())°",
                icon: WeatherIconModels(rawValue: iconCode) ?? .clearSkyDay
            )
        }
        
        return CityWeatherModel(
            name: city.name,
            country: city.country.countryName,
            weatherList: weatherInfos
        )
    }
}
