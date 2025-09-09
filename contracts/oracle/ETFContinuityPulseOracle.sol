// SPDX-License-Identifier: ETFContinuityPulse-License
pragma solidity ^0.8.0;

contract ETFContinuityPulseOracle {
    address public steward;

    struct Pulse {
        string asset;
        string clauseID;
        bool continuityConfirmed;
        uint256 flowMagnitude;
        uint256 timestamp;
    }

    Pulse[] public pulses;

    event PulseEmitted(string asset, string clauseID, bool continuityConfirmed, uint256 flowMagnitude, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory asset, string memory clauseID, bool continuityConfirmed, uint256 flowMagnitude) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(Pulse(asset, clauseID, continuityConfirmed, flowMagnitude, block.timestamp));
        emit PulseEmitted(asset, clauseID, continuityConfirmed, flowMagnitude, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, uint256, uint256) {
        Pulse memory p = pulses[index];
        return (p.asset, p.clauseID, p.continuityConfirmed, p.flowMagnitude, p.timestamp);
    }
}
