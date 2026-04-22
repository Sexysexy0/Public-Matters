// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AntiBloatProtocol {
    // [Goal: Prevent Budget Waste and Corporate Interference]
    function validateFeature(string memory _featureName, uint256 _cost) external pure returns (bool) {
        // Logic: If (Cost > UtilityValue), then REJECT.
        // Action: Keep the team lean and the code clean.
        return _cost < 100000; 
    }
}
