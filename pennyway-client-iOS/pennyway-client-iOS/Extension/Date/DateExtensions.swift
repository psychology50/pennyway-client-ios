
import Foundation

extension Date {
    /// year만 반환
    static func year(from date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year ?? 0
    }

    /// month만 반환
    static func month(from date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month ?? 0
    }

    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()

    var formattedCalendarDayDate: String {
        return Date.calendarDayDateFormatter.string(from: self)
    }
}
