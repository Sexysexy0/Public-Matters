// MedicinalPlantGrace.sol
// Logic: Distinguishing Natural Flora from Synthetic Poison
pragma solidity ^0.8.0;

contract MedicinalPlantGrace {
    function evaluateCultivation(uint256 _marketValue, bool _isSynthetic) public pure returns (string memory) {
        // Logic: 13k worth of plants vs Millions worth of Shabu.
        // If the plant is natural and value is low, prioritize "Regulation" over "Incarceration".
        if (!_isSynthetic && _marketValue <= 20000) {
            return "STATUS: RE-ROUTE TO MEDICAL REGULATION | LOW THREAT LEVEL";
        }
        return "STATUS: CRIMINAL INVESTIGATION REQUIRED";
    }
}
