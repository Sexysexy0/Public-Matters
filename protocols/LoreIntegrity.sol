// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LoreIntegrity {
    // [Goal: Ensure every action aligns with the long-term family narrative]
    function validatePurpose(string memory _action) external pure returns (string memory) {
        return string(abi.encodePacked("LORE_SYNCED: '", _action, "' is now part of the Greymane Legend."));
    }
}
