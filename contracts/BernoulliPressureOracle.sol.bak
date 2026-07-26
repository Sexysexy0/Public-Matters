// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BernoulliPressureOracle {
    uint256 public outdoorTemp;
    uint256 public absorberPlateTemp;

    // [3:00 - 4:22] Leveraging pressure differential for "No-Watt" cooling
    function calculateDraftVelocity() public view returns (uint256) {
        // Kapag mas mainit ang chimney kaysa sa loob,
        // automatic "Suction Mode" to pull fresh air into the home.
        return absorberPlateTemp - outdoorTemp;
    }
}
