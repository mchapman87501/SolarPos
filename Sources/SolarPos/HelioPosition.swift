// Provides the Earth's position with respect to the center of the sun.
public struct HelioPosition {
    public let longitude: Double
    public let latitude: Double
    public let radius: Double
    
    public init(jme: Double) {
        longitude = HelioPositionCalc.longitude(jme: jme)
        latitude = HelioPositionCalc.latitude(jme: jme)
        radius = HelioPositionCalc.earthRadiusVector(jme: jme)
    }
}
