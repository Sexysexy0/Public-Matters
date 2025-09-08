// FlightAccessOracle.js
import axios from "axios";

export async function fetchFlightAccessData(destination) {
  try {
    const response = await axios.get(
      `https://api.flightdata.ph/access/${destination}`,
    );
    const { hasDirectFlight, nextUpgradeDate, airportCode } = response.data;

    return {
      destination,
      hasDirectFlight,
      nextUpgradeDate,
      airportCode,
    };
  } catch (error) {
    console.error(`Flight access fetch failed for ${destination}:`, error);
    return null;
  }
}
