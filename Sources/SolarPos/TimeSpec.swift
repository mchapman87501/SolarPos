// Represents a local time of interest.
public struct TimeSpec {
    let year: Int   // 4-digit year - negative for years before start of Julian cal
    let month: UInt  // Month number, 1...12
    let day: UInt    // Day of month, 1...31
    let hour: UInt   // Hour of day, 0...23
    let minute: UInt // Minute of hour, 0...59
    let second: UInt // Second of minute, 0...59

    let gmtOffset: Int;  // Whole hours offset from GMT

    // From section 2, equation (2) of the paper:
    // ∆T is the difference between the Earth rotation time and the 
    // Terrestrial Time (TT). It is derived from observation only and 
    // reported yearly in the Astronomical Almanac [5]
    // NB: deltaT is in units of seconds.
    let deltaT: Double

    public static func forDate(
        _ year: Int, _ month: UInt, _ day: UInt) -> TimeSpec {
        return TimeSpec(year: year, month: month, day: day,
                        hour: 0, minute: 0, second: 0)
    }

    public init(
        year: Int, month: UInt, day: UInt,
        hour: UInt, minute: UInt, second: UInt,
        gmtOffset: Int = 0, deltaT: Double = 0.0) {
        // TODO Validate month, day, hour, etc.
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.gmtOffset = gmtOffset
        self.deltaT = deltaT
    }

    // Get day with day fraction (hours, minutes, seconds) added.
    // Include gmtOffset in the calculation
    func daytime() -> Double {
        let dday = Double(day)
        let hFract = Double(hour) / 24.0
        let mFract = Double(minute) / (24.0 * 60.0)
        let sFract = Double(second) / (24.0 * 60.0 * 60.0)
        let gmtFract = Double(gmtOffset) / 24.0
        let result = dday + hFract + mFract + sFract - gmtFract
        return result
    }

    // Get minutes since midnight - ignoring GMT offset.
    func minutesSinceMidnight() -> Double {
        return (Double(hour) * 60.0) + Double(minute) + (Double(second) / 60.0)
    }

    // What is the Swift idiom for __str__ or description?
    public func toStr() -> String {
        // TimeSpec's GMT offset is in whole hours rather than
        // hours + minutes.
        // hence this.
        return String(
            format: "%04d/%02d/%02d %02d:%02d:%02d %+03d00",
            year, month, day, hour, minute, second, gmtOffset)
    }
}
