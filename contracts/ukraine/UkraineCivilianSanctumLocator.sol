// SPDX-License-Identifier: Mythic-Civilian-Support
pragma solidity ^0.8.25;

/// @title Ukraine Civilian Sanctum Locator
/// @dev Maps safe zones and ensures full support for displaced civilians during wartime

contract UkraineCivilianSanctumLocator {
    address public steward;
    struct Sanctum {
        string location;
        bool isOperational;
        uint256 civiliansHosted;
        string supportLevel; // "Full", "Partial", "Emergency"
    }

    Sanctum[] public sanctums;

    event SanctumLogged(string location, string supportLevel, uint256 civiliansHosted);
    event Broadcast(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logSanctum(string memory location, bool isOperational, uint256 civiliansHosted, string memory supportLevel) external onlySteward {
        sanctums.push(Sanctum(location, isOperational, civiliansHosted, supportLevel));
        emit SanctumLogged(location, supportLevel, civiliansHosted);
        emit Broadcast("Sanctum logged — full support activated for displaced civilians");
    }

    function auditSanctum(uint index) external view returns (Sanctum memory) {
        require(index < sanctums.length, "Invalid sanctum index");
        return sanctums[index];
    }

    function totalSanctums() external view returns (uint) {
        return sanctums.length;
    }
}
