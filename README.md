# SolarPos

The SolarPos package is an implementation of NREL's [Solar Position Algorithm for Solar Radiation Applications](http://www.nrel.gov/docs/fy08osti/34302.pdf).  As noted in the paper, the algorithm is intended "to calculate solar zenith and azimuth angles in the period from the year -2000 to 6000, with uncertainties of $\pm0.0003^{\circ}$."

For most uses the main entity will be SolarPos, which calculates geocentric and topocentric angles for a given date/time and location on earth.
