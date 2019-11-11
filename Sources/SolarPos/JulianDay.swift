public struct JulianDay {
    static let daysPerJulianYear = 365.25
    static let daysPerJulianCentury = 36525.0
    static let startOfEpoch = 2451545.0
    static let secondsPerDay = 86400.0

    enum JulianDayError: Error {
        case invalidMonth
        case invalidDay
        case invalidSeconds
    }

    // Input parameters for a julian day, all (I guess) in GMT
    public let year: Int
    public let month: UInt
    public let day: Double // Day including fraction of a day since midnight

    public let julianDay: Double
    public let jde: Double // Julian Ephemeris Day

    // swiftlint:disable identifier_name
    public let jc: Double // Julian Century for the 2000 standard epoch
    // swiftlint:enable identifier_name

    public let jce: Double // Julian Ephemeris Century ditto
    public let jme: Double // Julian Ephemeris Millenium

    public init(timespec: TimeSpec) throws {
        try self.init(year: timespec.year, month: timespec.month,
                      day: timespec.daytime(), deltaT: timespec.deltaT)
    }

    public init(year: Int, month: UInt, day: Double, deltaT: Double = 0.0) throws {
        self.year = year
        self.month = month
        self.day = day

        let jday = try JulianDay.julianDay(year: year, month: month, day: day)
        julianDay = jday

        // NOTE: From section 2, equation (2) of the paper:
        // ∆T is the difference between the Earth rotation time and the
        // Terrestrial Time (TT). It is derived from observation only and
        // reported yearly in the Astronomical Almanac. [5]
        let jde = jday + deltaT / JulianDay.secondsPerDay
        self.jde = jde

        self.jc = JulianDay.calcJC(jday)
        let jce = JulianDay.calcJC(jde)

        self.jce = jce
        jme = jce / 10.0
    }

    // Derive a Julian Century from a Julian day value.
    public static func calcJC(_ jday: Double) -> Double {
        return (jday - JulianDay.startOfEpoch) / JulianDay.daysPerJulianCentury
    }

    static func julianDay(year: Int, month: UInt, day: Double) throws -> Double {
        guard (1 <= month) && (month <= 12) else {
            throw JulianDayError.invalidMonth
        }
        // Also check 0 <= day < 32
        let adjust = (month <= 2)
        let year = adjust ? year - 1 : year
        let month = adjust ? month + 12 : month

        let yearDays: Int = Int(365.25 * (Double(year) + 4716.0))
        let monthDays: Int = Int(30.6001 * Double(month + 1))
        let julian = Double(yearDays) + Double(monthDays) + day - 1524.5
        if julian > 2299160.0 {
            let century: Int = year / 100
            let gregCorr: Int = 2 - century + (century / 4)
            return julian + Double(gregCorr)
        }
        return julian
    }
}

// These aren't really JulianDay calculations.  They provide day-of-year ordinal
// calculations (getDayNum)
public extension JulianDay {

    private func isLeapYear(_ year: Int) -> Bool {
        // This calculation is correct only for positive years
        return ((year % 4) == 0) && (((year % 100) != 0) || ((year % 400) == 0))
    }

    private func getTotalDaysCurrYear() throws -> UInt {
        // Non leap-year days per month.
        let daysPerMonth: [UInt] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        let daysThisMonth = daysPerMonth[Int(month - 1)]
        let wholeDay = UInt(day)
        guard (1 <= wholeDay) && (wholeDay <= daysThisMonth) else {
            throw JulianDayError.invalidDay
        }
        // Add all of the non-leap-year days in all of the full months
        // *prior* to this month, and add to daysThisMonth
        return daysPerMonth[0..<(Int(month) - 1)].reduce(wholeDay) { $0 + $1 }
    }

    func getDayNum() throws -> UInt {
        let totalDays = try getTotalDaysCurrYear()
        let addLeapDay = isLeapYear(year) && (month > 2)
        return UInt(totalDays + (addLeapDay ? 1 : 0))
    }

}
