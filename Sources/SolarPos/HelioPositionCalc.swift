import Foundation

// Calculates Heliocentric Position coordinates using data from
// Table A.4.2 of "Solar Position Algorithm for Solar Radiation Applications",
// Ibrahim Reda and Afshin Andreas, NREL, Revised January 2008
// NREL/TP-560-34302
// The original algorithm is by Jean Meeus, "The Astronomical Algorithms", 
// which itself is derived from several other sources.
// Among those sources is the semi-analytic planetary theory, or "French VSOP87".
// This is available online (as is the newer VSOP2013).  It is described in
// more detail by Wikipedia: 
// https://en.wikipedia.org/wiki/VSOP_%28planets%29
// Also see PHP Science Labs:
// http://neoprogrammics.com/vsop87/
// "A copy of the original VSOP87 theory paper, published in the journal
// Astronomy and Astrophysics, 1988, vol. 202, p309-p315, is available on this
// site for review.   It explains the mathematical and technical foundations of
// the theory in its full, graphic, mathematical horror. " :) :)

// swiftlint:disable identifier_name type_body_length
internal struct HelioPositionCalc {
    struct EPTRec {
        let a: Double  // Amplitude
        let f: Double  // Frequency
        let p: Double  // Phase

        func value(jme: Double) -> Double {
            return a * cos(f + p * jme)
        }
    }

    static let l0 = [
        EPTRec(a: 175347046.0, f: 0.0, p: 0.0),  // So, a constant then
        EPTRec(a: 3341656.0, f: 4.66926, p: 6283.07585), // Frequency = 1 rev /year
        EPTRec(a: 34894.0, f: 4.6261, p: 12566.1517),    // 2 revs / year
        EPTRec(a: 3497.0, f: 2.7441, p: 5753.3849),      // ? from here out I don't understand the frequencies
        EPTRec(a: 3418.0, f: 2.8289, p: 3.5231),
        EPTRec(a: 3136.0, f: 3.6277, p: 77713.7715),
        EPTRec(a: 2676.0, f: 4.4181, p: 7860.4194),
        EPTRec(a: 2343.0, f: 6.1352, p: 3930.2097),
        EPTRec(a: 1324.0, f: 0.7425, p: 11506.7698),
        EPTRec(a: 1273.0, f: 2.0371, p: 529.691),
        EPTRec(a: 1199.0, f: 1.1096, p: 1577.3435),
        EPTRec(a: 990.0, f: 5.233, p: 5884.927),
        EPTRec(a: 902.0, f: 2.045, p: 26.298),
        EPTRec(a: 857.0, f: 3.508, p: 398.149),
        EPTRec(a: 780.0, f: 1.179, p: 5223.694),
        EPTRec(a: 753.0, f: 2.533, p: 5507.553),
        EPTRec(a: 505.0, f: 4.583, p: 18849.228),
        EPTRec(a: 492.0, f: 4.205, p: 775.523),
        EPTRec(a: 357.0, f: 2.92, p: 0.067),
        EPTRec(a: 317.0, f: 5.849, p: 11790.629),
        EPTRec(a: 284.0, f: 1.899, p: 796.298),
        EPTRec(a: 271.0, f: 0.315, p: 10977.079),
        EPTRec(a: 243.0, f: 0.345, p: 5486.778),
        EPTRec(a: 206.0, f: 4.806, p: 2544.314),
        EPTRec(a: 205.0, f: 1.869, p: 5573.143),
        EPTRec(a: 202.0, f: 2.458, p: 6069.777),
        EPTRec(a: 156.0, f: 0.833, p: 213.299),
        EPTRec(a: 132.0, f: 3.411, p: 2942.463),
        EPTRec(a: 126.0, f: 1.083, p: 20.775),
        EPTRec(a: 115.0, f: 0.645, p: 0.98),
        EPTRec(a: 103.0, f: 0.636, p: 4694.003),
        EPTRec(a: 102.0, f: 0.976, p: 15720.839),
        EPTRec(a: 102.0, f: 4.267, p: 7.114),
        EPTRec(a: 99.0, f: 6.21, p: 2146.17),
        EPTRec(a: 98.0, f: 0.68, p: 155.42),
        EPTRec(a: 86.0, f: 5.98, p: 161000.69),
        EPTRec(a: 85.0, f: 1.3, p: 6275.96),
        EPTRec(a: 85.0, f: 3.67, p: 71430.7),
        EPTRec(a: 80.0, f: 1.81, p: 17260.15),
        EPTRec(a: 79.0, f: 3.04, p: 12036.46),
        EPTRec(a: 75.0, f: 1.76, p: 5088.63),
        EPTRec(a: 74.0, f: 3.5, p: 3154.69),
        EPTRec(a: 74.0, f: 4.68, p: 801.82),
        EPTRec(a: 70.0, f: 0.83, p: 9437.76),
        EPTRec(a: 62.0, f: 3.98, p: 8827.39),
        EPTRec(a: 61.0, f: 1.82, p: 7084.9),
        EPTRec(a: 57.0, f: 2.78, p: 6286.6),
        EPTRec(a: 56.0, f: 4.39, p: 14143.5),
        EPTRec(a: 56.0, f: 3.47, p: 6279.55),
        EPTRec(a: 52.0, f: 0.19, p: 12139.55),
        EPTRec(a: 52.0, f: 1.33, p: 1748.02),
        EPTRec(a: 51.0, f: 0.28, p: 5856.48),
        EPTRec(a: 49.0, f: 0.49, p: 1194.45),
        EPTRec(a: 41.0, f: 5.37, p: 8429.24),
        EPTRec(a: 41.0, f: 2.4, p: 19651.05),
        EPTRec(a: 39.0, f: 6.17, p: 10447.39),
        EPTRec(a: 37.0, f: 6.04, p: 10213.29),
        EPTRec(a: 37.0, f: 2.57, p: 1059.38),
        EPTRec(a: 36.0, f: 1.71, p: 2352.87),
        EPTRec(a: 36.0, f: 1.78, p: 6812.77),
        EPTRec(a: 33.0, f: 0.59, p: 17789.85),
        EPTRec(a: 30.0, f: 0.44, p: 83996.85),
        EPTRec(a: 30.0, f: 2.74, p: 1349.87),
        EPTRec(a: 25.0, f: 3.16, p: 4690.48)
    ]

    static let l1 = [
        EPTRec(a: 628331966747.0, f: 0.0, p: 0.0),
        EPTRec(a: 206059.0, f: 2.67824, p: 6283.07585),
        EPTRec(a: 4303.0, f: 2.6351, p: 12566.1517),
        EPTRec(a: 425.0, f: 1.59, p: 3.523),
        EPTRec(a: 119.0, f: 5.796, p: 26.298),
        EPTRec(a: 109.0, f: 2.966, p: 1577.344),
        EPTRec(a: 93.0, f: 2.59, p: 18849.23),
        EPTRec(a: 72.0, f: 1.14, p: 529.69),
        EPTRec(a: 68.0, f: 1.87, p: 398.15),
        EPTRec(a: 67.0, f: 4.41, p: 5507.55),
        EPTRec(a: 59.0, f: 2.89, p: 5223.69),
        EPTRec(a: 56.0, f: 2.17, p: 155.42),
        EPTRec(a: 45.0, f: 0.4, p: 796.3),
        EPTRec(a: 36.0, f: 0.47, p: 775.52),
        EPTRec(a: 29.0, f: 2.65, p: 7.11),
        EPTRec(a: 21.0, f: 5.34, p: 0.98),
        EPTRec(a: 19.0, f: 1.85, p: 5486.78),
        EPTRec(a: 19.0, f: 4.97, p: 213.3),
        EPTRec(a: 17.0, f: 2.99, p: 6275.96),
        EPTRec(a: 16.0, f: 0.03, p: 2544.31),
        EPTRec(a: 16.0, f: 1.43, p: 2146.17),
        EPTRec(a: 15.0, f: 1.21, p: 10977.08),
        EPTRec(a: 12.0, f: 2.83, p: 1748.02),
        EPTRec(a: 12.0, f: 3.26, p: 5088.63),
        EPTRec(a: 12.0, f: 5.27, p: 1194.45),
        EPTRec(a: 12.0, f: 2.08, p: 4694.0),
        EPTRec(a: 11.0, f: 0.77, p: 553.57),
        EPTRec(a: 10.0, f: 1.3, p: 6286.6),
        EPTRec(a: 10.0, f: 4.24, p: 1349.87),
        EPTRec(a: 9.0, f: 2.7, p: 242.73),
        EPTRec(a: 9.0, f: 5.64, p: 951.72),
        EPTRec(a: 8.0, f: 5.3, p: 2352.87),
        EPTRec(a: 6.0, f: 2.65, p: 9437.76),
        EPTRec(a: 6.0, f: 4.67, p: 4690.48)
    ]

    static let l2 = [
        EPTRec(a: 52919.0, f: 0.0, p: 0.0),
        EPTRec(a: 8720.0, f: 1.0721, p: 6283.0758),
        EPTRec(a: 309.0, f: 0.867, p: 12566.152),
        EPTRec(a: 27.0, f: 0.05, p: 3.52),
        EPTRec(a: 16.0, f: 5.19, p: 26.3),
        EPTRec(a: 16.0, f: 3.68, p: 155.42),
        EPTRec(a: 10.0, f: 0.76, p: 18849.23),
        EPTRec(a: 9.0, f: 2.06, p: 77713.77),
        EPTRec(a: 7.0, f: 0.83, p: 775.52),
        EPTRec(a: 5.0, f: 4.66, p: 1577.34),
        EPTRec(a: 4.0, f: 1.03, p: 7.11),
        EPTRec(a: 4.0, f: 3.44, p: 5573.14),
        EPTRec(a: 3.0, f: 5.14, p: 796.3),
        EPTRec(a: 3.0, f: 6.05, p: 5507.55),
        EPTRec(a: 3.0, f: 1.19, p: 242.73),
        EPTRec(a: 3.0, f: 6.12, p: 529.69),
        EPTRec(a: 3.0, f: 0.31, p: 398.15),
        EPTRec(a: 3.0, f: 2.28, p: 553.57),
        EPTRec(a: 2.0, f: 4.38, p: 5223.69),
        EPTRec(a: 2.0, f: 3.75, p: 0.98)
    ]

    static let l3 = [
        EPTRec(a: 289.0, f: 5.844, p: 6283.076),
        EPTRec(a: 35.0, f: 0.0, p: 0.0),
        EPTRec(a: 17.0, f: 5.49, p: 12566.15),
        EPTRec(a: 3.0, f: 5.2, p: 155.42),
        EPTRec(a: 1.0, f: 4.72, p: 3.52),
        EPTRec(a: 1.0, f: 5.3, p: 18849.23),
        EPTRec(a: 1.0, f: 5.97, p: 242.73)
    ]

    static let l4 = [
        EPTRec(a: 114.0, f: 3.142, p: 0.0),
        EPTRec(a: 8.0, f: 4.13, p: 6283.08),
        EPTRec(a: 1.0, f: 3.84, p: 12566.15)
    ]

    static let l5 = [
        EPTRec(a: 1.0, f: 3.14, p: 0.0)
    ]

    static let b0 = [
            EPTRec(a: 280.0, f: 3.199, p: 84334.662),
            EPTRec(a: 102.0, f: 5.422, p: 5507.553),
            EPTRec(a: 80.0, f: 3.88, p: 5223.69),
            EPTRec(a: 44.0, f: 3.7, p: 2352.87),
            EPTRec(a: 32.0, f: 4.0, p: 1577.34)
    ]

    static let b1 = [
        EPTRec(a: 9.0, f: 3.9, p: 5507.55),
        EPTRec(a: 6.0, f: 1.73, p: 5223.69)
    ]

    static let r0 = [
        EPTRec(a: 100013989.0, f: 0.0, p: 0.0),
        EPTRec(a: 1670700.0, f: 3.09846, p: 6283.07585),
        EPTRec(a: 13956.0, f: 3.05525, p: 12566.1517),
        EPTRec(a: 3084.0, f: 5.1985, p: 77713.7715),
        EPTRec(a: 1628.0, f: 1.1739, p: 5753.3849),
        EPTRec(a: 1576.0, f: 2.8469, p: 7860.4194),
        EPTRec(a: 925.0, f: 5.453, p: 11506.77),
        EPTRec(a: 542.0, f: 4.564, p: 3930.21),
        EPTRec(a: 472.0, f: 3.661, p: 5884.927),
        EPTRec(a: 346.0, f: 0.964, p: 5507.553),
        EPTRec(a: 329.0, f: 5.9, p: 5223.694),
        EPTRec(a: 307.0, f: 0.299, p: 5573.143),
        EPTRec(a: 243.0, f: 4.273, p: 11790.629),
        EPTRec(a: 212.0, f: 5.847, p: 1577.344),
        EPTRec(a: 186.0, f: 5.022, p: 10977.079),
        EPTRec(a: 175.0, f: 3.012, p: 18849.228),
        EPTRec(a: 110.0, f: 5.055, p: 5486.778),
        EPTRec(a: 98.0, f: 0.89, p: 6069.78),
        EPTRec(a: 86.0, f: 5.69, p: 15720.84),
        EPTRec(a: 86.0, f: 1.27, p: 161000.69),
        EPTRec(a: 65.0, f: 0.27, p: 17260.15),
        EPTRec(a: 63.0, f: 0.92, p: 529.69),
        EPTRec(a: 57.0, f: 2.01, p: 83996.85),
        EPTRec(a: 56.0, f: 5.24, p: 71430.7),
        EPTRec(a: 49.0, f: 3.25, p: 2544.31),
        EPTRec(a: 47.0, f: 2.58, p: 775.52),
        EPTRec(a: 45.0, f: 5.54, p: 9437.76),
        EPTRec(a: 43.0, f: 6.01, p: 6275.96),
        EPTRec(a: 39.0, f: 5.36, p: 4694.0),
        EPTRec(a: 38.0, f: 2.39, p: 8827.39),
        EPTRec(a: 37.0, f: 0.83, p: 19651.05),
        EPTRec(a: 37.0, f: 4.9, p: 12139.55),
        EPTRec(a: 36.0, f: 1.67, p: 12036.46),
        EPTRec(a: 35.0, f: 1.84, p: 2942.46),
        EPTRec(a: 33.0, f: 0.24, p: 7084.9),
        EPTRec(a: 32.0, f: 0.18, p: 5088.63),
        EPTRec(a: 32.0, f: 1.78, p: 398.15),
        EPTRec(a: 28.0, f: 1.21, p: 6286.6),
        EPTRec(a: 28.0, f: 1.9, p: 6279.55),
        EPTRec(a: 26.0, f: 4.59, p: 10447.39)
    ]

    static let r1 = [
        EPTRec(a: 103019.0, f: 1.10749, p: 6283.07585),
        EPTRec(a: 1721.0, f: 1.0644, p: 12566.1517),
        EPTRec(a: 702.0, f: 3.142, p: 0.0),
        EPTRec(a: 32.0, f: 1.02, p: 18849.23),
        EPTRec(a: 31.0, f: 2.84, p: 5507.55),
        EPTRec(a: 25.0, f: 1.32, p: 5223.69),
        EPTRec(a: 18.0, f: 1.42, p: 1577.34),
        EPTRec(a: 10.0, f: 5.91, p: 10977.08),
        EPTRec(a: 9.0, f: 1.42, p: 6275.96),
        EPTRec(a: 9.0, f: 0.27, p: 5486.78)
    ]

    static let r2 = [
        EPTRec(a: 4359.0, f: 5.7846, p: 6283.0758),
        EPTRec(a: 124.0, f: 5.579, p: 12566.152),
        EPTRec(a: 12.0, f: 3.14, p: 0.0),
        EPTRec(a: 9.0, f: 3.63, p: 77713.77),
        EPTRec(a: 6.0, f: 1.87, p: 5573.14),
        EPTRec(a: 3.0, f: 5.47, p: 18849.23)
    ]

    static let r3 = [
        EPTRec(a: 145.0, f: 4.273, p: 6283.076),
        EPTRec(a: 7.0, f: 3.92, p: 12566.15)
    ]

    static let r4 = [
        EPTRec(a: 4.0, f: 2.56, p: 6283.08)
    ]

    // Get a lat-lon term for a given Julian ephemeris date
    // I don't understand these coefficients.  The general form is reminiscent
    // of a Fourier series, but the frequencies do not vary by a constant
    // amount.  And the terms are used as coefficients of a polynomial, up to
    // order 5.
    // I believe these calculations are derived from:
    // Meeus, Jean. Astronomical Algorithms, 2nd Edition
    // Chapter 25, Solar Coordinates - the "Higher accuracy" section
    // This section is itself derived from
    // Bretagnon and Simon. Planetary Programs and Tables from -4000 to +2800
    // (Wilmann-Bell, Richmond; 1986)
    internal static func getLValue(
        _ jme: Double, _ params: [EPTRec]) -> Double {
        let terms = params.map { $0.value(jme: jme) }
        let result = terms.reduce(0.0) { $0 + $1 }
        return result
    }

    private static func polynomial(
        jme: Double, tables: [[EPTRec]]) -> Double {
        let coeffs = tables.map { getLValue(jme, $0) }
        let unscaled = poly(coeffs: coeffs, x: jme)
        return unscaled / 1.0e8
    }
    /**
     * Get heliocentric longitude, degrees
     */
    private static let longPolyTables = [l0, l1, l2, l3, l4, l5]

    static func longitude(jme: Double) -> Double {
        return oneRev(degrees(polynomial(jme: jme, tables: longPolyTables)))
    }

    static func latitude(jme: Double) -> Double {
        let modulated = oneRev(degrees(polynomial(jme: jme, tables: [b0, b1])))
        return (modulated <= 180.0) ? modulated : modulated - 360.0
    }

    // Get Earth radius vector in Astronomical Units (AU)
    static func earthRadiusVector(jme: Double) -> Double {
        return polynomial(jme: jme, tables: [r0, r1, r2, r3, r4])
    }
}
