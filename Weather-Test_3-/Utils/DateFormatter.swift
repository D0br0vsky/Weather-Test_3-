import Foundation

final class DateFormatterHelper {
    static let shared = DateFormatterHelper()
    
    private let inputFormatter: DateFormatter
    
    private init() {
        inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    func formatToWeekday(from dateString: String) -> String {
        guard let date = inputFormatter.date(from: dateString) else {
            return "no data"
        }
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return weekdays[weekday - 1]
    }
}
