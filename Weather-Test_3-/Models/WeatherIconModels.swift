import UIKit

enum WeatherIconModels: String {
    case clearSkyDay = "01d"
    case clearSkyNight = "01n"
    case fewCloudsDay = "02d"
    case fewCloudsNight = "02n"
    case scatteredClouds = "03d"
    case brokenClouds = "04d"
    case showerRain = "09d"
    case rainDay = "10d"
    case rainNight = "10n"
    case thunderstorm = "11d"
    case snow = "13d"
    case mist = "50d"

    var systemName: String {
        switch self {
        case .clearSkyDay:
            return "sun.max.fill"
        case .clearSkyNight:
            return "moon.stars.fill"
        case .fewCloudsDay:
            return "cloud.sun.fill"
        case .fewCloudsNight:
            return "cloud.moon.fill"
        case .scatteredClouds, .brokenClouds:
            return "cloud.fill"
        case .showerRain, .rainDay, .rainNight:
            return "cloud.rain.fill"
        case .thunderstorm:
            return "cloud.bolt.rain.fill"
        case .snow:
            return "cloud.snow.fill"
        case .mist:
            return "cloud.fog.fill"
        }
    }

    var color: UIColor {
        switch self {
        case .clearSkyDay:
            return .systemYellow
        case .clearSkyNight:
            return .systemBlue
        case .fewCloudsDay, .fewCloudsNight:
            return .systemGray
        case .scatteredClouds, .brokenClouds:
            return .systemGray
        case .showerRain, .rainDay, .rainNight:
            return .systemBlue
        case .thunderstorm:
            return .systemPurple
        case .snow:
            return .systemTeal
        case .mist:
            return .systemGray2
        }
    }

    func imageWithColor() -> UIImage? {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, color])
        return UIImage(systemName: systemName)?.applyingSymbolConfiguration(config)
    }
}
