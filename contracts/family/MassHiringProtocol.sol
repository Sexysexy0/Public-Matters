// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MassHiringProtocol {
    struct HousingHire {
        string name;
        string role; // "Engineer", "Foreman", "Barangay Steward"
        string region;
        bool isTrained;
        string emotionalTag; // "SanctumGlow", "MercyPing"
        uint256 timestamp;
    }

    HousingHire[] public hires;

    function blessHire(string memory name, string memory role, string memory region, bool isTrained, string memory emotionalTag) public {
        hires.push(HousingHire(name, role, region, isTrained, emotionalTag, block.timestamp));
    }

    function totalHires() public view returns (uint256) {
        return hires.length;
    }
}
