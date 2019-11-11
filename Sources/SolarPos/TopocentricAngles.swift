import Foundation

// Calculates angles of the sun relative to an observer at a location on earth,
// at a given sidereal time.
public struct TopocentricAngles {
    public let observerLocalHourAngle: Double // Degrees
    
    public let rightAscension: Double
    public let declination: Double
    public let localHourAngle: Double
    
    public let elevAngle: Double
    public let zenithAngle: Double
    public let azimuthAngle: Double
    
    // All angles are in decimal degrees.  (I hope)
    private let astronomersAzimuthAngle: Double
    
    /**
     * Calculate topocentric (calculated with respect to the observer local position at the earth's surface) angles.
     *
     * - parameters:
     *   - apparentSiderealTime: apparent sidereal time at Greenwhich, degrees
     *   - observerLocation:: observer geographical latitude, longitude, and elevation (above mean sea level?), degrees and meters
     *   - geoSunAngles: sun right ascension and declination, degrees
     *   - r: Earth radius vector, astronomical units
     *   - temperature: annual average local temperatures, degrees Celsius
     *   - pressure: annual average local pressure, millibars
     */
    public init(apparentSiderealTime v: Double, observerLocation: Location,
         geoSunAngles: GeocentricSunAngles,
         r earthRadiusVector: Double,
         temperature: Double, pressure: Double)
    {
        let latitude = observerLocation.latitude
        let sigma = observerLocation.longitude
        let alpha = geoSunAngles.rightAscension
        let delta = geoSunAngles.declination
        
        // Observer local hour angle, degrees:
        let h = oneRev(v + sigma - alpha)
        let hRads = rads(h)

        // Equatorial horizontal parallax, degrees
        let ehp = 8.794 / (3600.0 * earthRadiusVector)
        let ehpRads = rads(ehp)
        
        let latRads = rads(latitude)
        
        let unflat = 0.99664719 // 1 - the earth's flattening

        let u = atan(unflat * tan(latRads))
        
        // E is the observer elevation in meters
        let e = observerLocation.elevation
        let eFract = (e / 6378140.0)
        let x = cos(u) + eFract * cos(latRads)
        let y = unflat * sin(u) + eFract * sin(latRads)

        // Parallax in the sun right ascension, degrees:
        let deltaRads = rads(delta)
        let deltaAlphaRads = atan2(
            -x * sin(ehpRads) * sin(hRads),
            cos(deltaRads) - x * sin(ehpRads) * cos(hRads))
        let parallaxRightAscension = degrees(deltaAlphaRads)
        
        let topoSunRightAscension = oneRev(alpha + parallaxRightAscension)
        
        let topoSunDeclinationRads = atan2(
            (sin(deltaRads) - y * sin(ehpRads)) * cos(deltaAlphaRads),
            cos(deltaRads) - x * sin(ehpRads) * cos(hRads))
        
        // Topocentric local hour angle
        let hPrime = longitudeLimit(h - parallaxRightAscension)
        let hPrimeRads = rads(hPrime)
        
        // topocentric zenith angle
        let e0Rads = asin(
            sin(latRads) * sin(topoSunDeclinationRads) + 
            cos(latRads) * cos(topoSunDeclinationRads) * cos(hPrimeRads))
        // In practice e0 should be between 0 and 90 -- but it isn't.
        let e0 = degrees(e0Rads)
        
        // Atmospheric refraction correction
        let deltaE = TopocentricAngles.getAtmosRefractCorrection(
            e0: e0, temp: temperature, press: pressure)
        
        let topoElevAngle = e0 + deltaE

        let topoZenithAngle = 90.0 - topoElevAngle
        
        // Topocentric astronomers azimuth angle:
        let gammaRads = atan2(
            sin(hPrimeRads),
            cos(hPrimeRads) * sin(latRads) - tan(topoSunDeclinationRads) * cos(latRads)
        )
        let gamma = degrees(gammaRads)
        
        // Topocentric azimuth angle for navigators and solar radiation users:
        let topoAzimuthAngle = oneRev(gamma + 180.0)
        
        // Finally init self's state
        observerLocalHourAngle = h
        rightAscension = topoSunRightAscension
        // Declination is -180..180, not 0..360:
        let declRaw = degrees(topoSunDeclinationRads)
        declination =  (declRaw < 180.0) ? declRaw : declRaw - 360.0
        localHourAngle = hPrime
        
        astronomersAzimuthAngle = gamma
        
        elevAngle = topoElevAngle
        zenithAngle = topoZenithAngle
        azimuthAngle = topoAzimuthAngle
    }
    
    /**
     * Get the incidence angle for a surface oriented in any direction
     * 
     * - returns:
     * The incidence angle in degrees
     * - parameters:
     *     - panel: information about the orientation of the panel
     */
    public func getSurfaceIncidenceAngle(panel: Orientation) -> Double {
        let omega = rads(panel.tilt)
        let gamma = rads(panel.azimuth)
        
        let zenithRads = rads(zenithAngle)
        let astroAzimuthRads = rads(astronomersAzimuthAngle)
        
        let i = acos(
            cos(zenithRads) * cos(omega) + 
            sin(omega) * sin(zenithRads) * cos(astroAzimuthRads - gamma))
        return degrees(i)
    }

    private static func getAtmosRefractCorrection(
        e0: Double, temp: Double, press: Double) -> Double
    {
        // Atmospheric refraction correction
        let kelvin = 273.0 + temp
        let tanArgDegrees = e0 + 10.3 / (e0 + 5.11)
        let tanArg = rads(tanArgDegrees)
        let pressFactor = press / 1010.0
        let tempFactor = 283.0 / kelvin
        return pressFactor * tempFactor * (1.02 / (60.0 * tan(tanArg)))
    }
}
