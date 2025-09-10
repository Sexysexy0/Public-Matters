// SPDX-License-Identifier: InvisibleLiquidityPulse-License
pragma solidity ^0.8.0;

contract InvisibleLiquidityPulseOracle {
    address public steward;

    struct PulseSignal {
        string originPair;
        string cloakedPair;
        bool pulseConfirmed;
        string APRImpact;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event LiquidityPulseEmitted(string originPair, string cloakedPair, bool pulseConfirmed, string APRImpact, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory originPair, string memory cloakedPair, bool pulseConfirmed, string memory APRImpact) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(PulseSignal(originPair, cloakedPair, pulseConfirmed, APRImpact, block.timestamp));
        emit LiquidityPulseEmitted(originPair, cloakedPair, pulseConfirmed, APRImpact, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PulseSignal memory s = signals[index];
        return (s.originPair, s.cloakedPair, s.pulseConfirmed, s.APRImpact, s.timestamp);
    }
}
