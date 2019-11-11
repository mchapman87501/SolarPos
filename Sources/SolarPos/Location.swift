public struct Location {
    public let latitude: Double
    public let longitude: Double
    public let elevation: Double // Elevation above mean sea level, meters (I think)
    
    public init(lat: Double, lon: Double, elev: Double = 0.0) {
        latitude = lat
        longitude = lon
        elevation = elev
    }
}
