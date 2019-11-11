public struct GeocentricPosition {
    public let longitude: Double
    public let latitude: Double

    public init(_ helioPos: HelioPosition) {
        longitude = GeocentricPosition.getLongitude(helioPos.longitude)
        latitude = GeocentricPosition.getLatitude(helioPos.latitude)
    }

    private static func getLongitude(_ heliocentricLongitude: Double) -> Double {
        return oneRev(heliocentricLongitude + 180.0)
    }

    private static func getLatitude(_ heliocentricLatitude: Double) -> Double {
        return -heliocentricLatitude
    }
}
