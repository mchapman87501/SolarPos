import Foundation

// Convert a pressure in inches of Mercury to a pressure in millibars
func mbar(_ inHg: Double) -> Double {
    let mbarsPerInHg = 1000.0 / 29.53
    return inHg * mbarsPerInHg
}
