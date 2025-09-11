// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalSanctumRegistry {
    enum SanctumType { Civic, Health, Ancestral, Educational, Emotional, Agricultural }

    struct Sanctum {
        string sanctumId;
        string name;
        SanctumType sanctumType;
        string location;
        string steward;
        bool emotionallyCalibrated;
        bool treatyProtected;
        uint256 timestamp;
    }

    mapping(string => Sanctum) public sanctumLedger;

    event SanctumRegistered(
        string sanctumId,
        string name,
        SanctumType sanctumType,
        string location,
        string steward,
        bool emotionallyCalibrated,
        bool treatyProtected
    );

    function registerSanctum(
        string memory sanctumId,
        string memory name,
        SanctumType sanctumType,
        string memory location,
        string memory steward,
        bool emotionallyCalibrated,
        bool treatyProtected
    ) public {
        sanctumLedger[sanctumId] = Sanctum(
            sanctumId,
            name,
            sanctumType,
            location,
            steward,
            emotionallyCalibrated,
            treatyProtected,
            block.timestamp
        );

        emit SanctumRegistered(
            sanctumId,
            name,
            sanctumType,
            location,
            steward,
            emotionallyCalibrated,
            treatyProtected
        );
    }

    function getSanctumDetails(string memory sanctumId) public view returns (Sanctum memory) {
        return sanctumLedger[sanctumId];
    }
}
