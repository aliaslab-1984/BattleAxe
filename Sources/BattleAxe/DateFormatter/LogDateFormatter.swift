import Foundation

public final class LogDateFormatter: DateFormatter {
    public convenience init(dateFormat: String = "yyyy-MM-dd HH:mm:ssSSS") {
        self.init()
        self.dateFormat = dateFormat
        self.locale = Locale.current
        self.timeZone = TimeZone.current
    }
}

extension DateFormatter {
    func getCurrentDateAsString(date: Date = .init()) -> String {
        return self.string(from: date)
    }
}
