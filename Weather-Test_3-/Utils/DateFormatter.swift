import Foundation

final class DateFormatterHelper {
    static let shared = DateFormatterHelper()
    
    private let inputFormatter: DateFormatter
    private let outputFormatter: DateFormatter
    
    private init() {
        inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ru_RU")
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "EEEE"
    }
    
    func parseDate(from dateString: String) -> Date? {
        inputFormatter.date(from: dateString)
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
    
    func formatYMD(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
