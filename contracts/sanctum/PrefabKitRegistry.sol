// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PrefabKitRegistry {
    struct PrefabKit {
        string kitID;
        string supplier;
        string spec; // "2BR Modular", "Vertical Stack", etc.
        string barangay;
        string emotionalTag; // "SanctumGlow", "AuditGlow"
        bool isBlessed;
        uint256 timestamp;
    }

    PrefabKit[] public kits;

    function registerKit(string memory kitID, string memory supplier, string memory spec, string memory barangay, string memory emotionalTag, bool isBlessed) public {
        kits.push(PrefabKit(kitID, supplier, spec, barangay, emotionalTag, isBlessed, block.timestamp));
    }

    function totalKits() public view returns (uint256) {
        return kits.length;
    }
}
