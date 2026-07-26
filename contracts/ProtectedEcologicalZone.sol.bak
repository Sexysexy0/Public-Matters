// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProtectedEcologicalZone {
    struct Zone {
        string name;
        bool isPristine;
        uint256 biodiversityScore;
    }

    mapping(uint256 => Zone) public zones;

    // [Rule: Nature over Profit]
    // Blocks any industrial transaction if the zone is marked "Pristine"
    function requestExtraction(uint256 _zoneID) public view {
        require(!zones[_zoneID].isPristine, "ERROR: Protected Sanctuary. Extraction Prohibited.");
        // Ang system mismo ang nagsasabing "HINDI PWEDE."
    }
}
