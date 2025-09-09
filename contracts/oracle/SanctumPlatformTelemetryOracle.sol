// SPDX-License-Identifier: SanctumPlatformTelemetry-License
pragma solidity ^0.8.0;

contract SanctumPlatformTelemetryOracle {
    address public steward;

    struct PlatformPulse {
        string platformID;
        string clauseID;
        bool activated;
        string originSanctum;
        uint256 timestamp;
    }

    PlatformPulse[] public pulses;

    event PulseEmitted(string platformID, string clauseID, bool activated, string originSanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory platformID, string memory clauseID, bool activated, string memory originSanctum) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(PlatformPulse(platformID, clauseID, activated, originSanctum, block.timestamp));
        emit PulseEmitted(platformID, clauseID, activated, originSanctum, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PlatformPulse memory p = pulses[index];
        return (p.platformID, p.clauseID, p.activated, p.originSanctum, p.timestamp);
    }
}
