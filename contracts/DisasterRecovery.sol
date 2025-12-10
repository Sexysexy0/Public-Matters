// contracts/DisasterRecovery.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DisasterRecovery
 * @notice Protocols for calamity response, housing reallocation, asset replacement, and communal aid.
 */
contract DisasterRecovery {
    address public admin;

    struct RecoveryEvent {
        string disasterType; // e.g., "Typhoon", "Flood", "Earthquake"
        string action;       // e.g., "Housing Reallocation", "Asset Replacement"
        string note;
        uint256 timestamp;
    }

    RecoveryEvent[] public events;

    event RecoveryLogged(string disasterType, string action, string note, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logRecovery(string calldata disasterType, string calldata action, string calldata note) external onlyAdmin {
        events.push(RecoveryEvent(disasterType, action, note, block.timestamp));
        emit RecoveryLogged(disasterType, action, note, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    function getEvent(uint256 id) external view returns (RecoveryEvent memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
