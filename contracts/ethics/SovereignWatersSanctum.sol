// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title SovereignWatersSanctum
/// @notice Affirms stewardship over EEZs and rejects imperial ownership of seas
contract SovereignWatersSanctum {
    string public doctrine = "No nation owns the sea. Stewardship is earned through protection, not provocation.";

    function getDoctrine() public view returns (string memory) {
        return doctrine;
    }
}
