import XCTest
@testable import SolarPos

class TimeSpecTests: XCTestCase {
    func testForDate() throws {
        let tspec = TimeSpec.forDate(2000, 1, 31)
        XCTAssertEqual(tspec.year, 2000)
        XCTAssertEqual(tspec.month, 1)
        XCTAssertEqual(tspec.day, 31)
        XCTAssertEqual(tspec.hour, 0)
        XCTAssertEqual(tspec.minute, 0)
        XCTAssertEqual(tspec.second, 0)
        XCTAssertEqual(tspec.gmtOffset, 0)
        XCTAssertEqual(tspec.deltaT, 0)
    }

    func testMinutesSinceMidnight() throws {
        let hmsValues: [(Int, Int, Int)] = {
            var result: [(Int, Int, Int)] = []
            for hour in stride(from: 0, through: 23, by: 2) {
                for minute in stride(from: 0, through: 59, by: 5) {
                    for second in stride(from: 3, through: 59, by: 3) {
                        result.append((hour, minute, second))
                    }
                }
            }
            return result
        }()

        let ymdValues: [(Int, Int, Int)] = {
            var result: [(Int, Int, Int)] = []
            for year in [2019, 2036, 2050] {
                for month in [3, 6, 10] {
                    for day in [1, 14, 30] {
                        result.append((year, month, day))
                    }
                }
            }
            return result
        }()

        for (year, month, day) in ymdValues {
            for (hour, minute, second) in hmsValues {
                let expected = (
                    Double(hour) * 60.0 + Double(minute) +
                    Double(second) / 60.0)
                let tspec = TimeSpec(
                    year: year, month: UInt(month), day: UInt(day),
                    hour: UInt(hour), minute: UInt(minute), second: UInt(second))
                let actual = tspec.minutesSinceMidnight()
                XCTAssertEqual(actual, expected)
            }
        }
    }

    static var allTests = [
        ("testForDate", testForDate),
        ("testMinutesSinceMidnight", testMinutesSinceMidnight)
    ]
}
