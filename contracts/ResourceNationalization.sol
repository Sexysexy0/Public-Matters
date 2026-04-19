// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResourceNationalization {
    // [GOAL: Use natural resources for electronics/batteries]
    function validateExport(string memory _resource, bool _isProcessedLocally) public pure returns (string memory) {
        if (_resource == "Nickel" || _resource == "Copper") {
            require(_isProcessedLocally, "ERROR: Raw export denied. Must add value in Luzon Tech Zone.");
            return "SUCCESS: High-value product authorized for global supply chain.";
        }
        return "STATUS: Standard Trade.";
    }
}
