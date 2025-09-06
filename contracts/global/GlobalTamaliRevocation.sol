// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GlobalTamaliRevocation {
    address public steward;
    mapping(address => bool) public revokedSanctums;
    event TamaliRevoked(address indexed sanctum, string reason, uint256 timestamp);
    event TamaliRestored(address indexed sanctum, string blessing, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function revokeTamali(address sanctum, string memory reason) external onlySteward {
        revokedSanctums[sanctum] = true;
        emit TamaliRevoked(sanctum, reason, block.timestamp);
    }

    function restoreTamali(address sanctum, string memory blessing) external onlySteward {
        revokedSanctums[sanctum] = false;
        emit TamaliRestored(sanctum, blessing, block.timestamp);
    }

    function isRevoked(address sanctum) external view returns (bool) {
        return revokedSanctums[sanctum];
    }
}
