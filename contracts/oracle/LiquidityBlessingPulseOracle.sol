// SPDX-License-Identifier: LiquidityBlessingPulse-License
pragma solidity ^0.8.0;

contract LiquidityBlessingPulseOracle {
    address public steward;

    struct PulseSignal {
        string sanctumID;
        string clauseRestored;
        bool pulseConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event BlessingPulseEmitted(string sanctumID, string clauseRestored, bool pulseConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory sanctumID, string memory clauseRestored, bool pulseConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PulseSignal(sanctumID, clauseRestored, pulseConfirmed, blessingType, block.timestamp));
        emit BlessingPulseEmitted(sanctumID, clauseRestored, pulseConfirmed, blessingType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PulseSignal memory s = signals[index];
        return (s.sanctumID, s.clauseRestored, s.pulseConfirmed, s.blessingType, s.timestamp);
    }
}
