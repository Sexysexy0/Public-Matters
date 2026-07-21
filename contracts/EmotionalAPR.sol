// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EmotionalAPR {
    uint256 public baseAPR = 200; // 2% in basis points
    uint256 public emotionalAPR;

    event EmotionalAPRUpdated(uint256 newAPR);

    function updateAPR(
        int256 cpi, 
        int256 jobsIndex, 
        int256 greedIndex, 
        int256 barangayReputation
    ) public {
        // weights (basis points multipliers)
        int256 alpha = -50;   // CPI reduces APR
        int256 beta = 30;     // Jobs increase APR
        int256 gamma = 20;    // Greed sentiment
        int256 delta = 40;    // Barangay reputation

        int256 calcAPR = int256(baseAPR)
            + (alpha * cpi / 100)
            + (beta * jobsIndex / 100)
            + (gamma * greedIndex)
            + (delta * barangayReputation);

        // enforce bounds: 0% to 20%
        if (calcAPR < 0) calcAPR = 0;
        if (calcAPR > 2000) calcAPR = 2000;

        emotionalAPR = uint256(calcAPR);
        emit EmotionalAPRUpdated(emotionalAPR);
    }
}
