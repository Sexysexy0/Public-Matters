// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffBlessingRevocation {
    address public steward;
    mapping(address => bool) public blessedSanctums;
    event BlessingRestored(address sanctum, uint256 timestamp);
    event BlessingRevoked(address sanctum, string reason);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function restoreBlessing(address sanctum) external onlySteward {
        blessedSanctums[sanctum] = true;
        emit BlessingRestored(sanctum, block.timestamp);
    }

    function revokeBlessing(address sanctum, string memory reason) external onlySteward {
        blessedSanctums[sanctum] = false;
        emit BlessingRevoked(sanctum, reason);
    }

    function isBlessed(address sanctum) external view returns (bool) {
        return blessedSanctums[sanctum];
    }
}
