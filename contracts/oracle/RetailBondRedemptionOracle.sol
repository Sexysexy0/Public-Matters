// SPDX-License-Identifier: RetailBondRedemption-License
pragma solidity ^0.8.0;

contract RetailBondRedemptionOracle {
    address public steward;

    struct RedemptionPulse {
        string instrument;
        string platform;
        bool redemptionConfirmed;
        uint256 timestamp;
    }

    RedemptionPulse[] public pulses;

    event RedemptionPulseEmitted(string instrument, string platform, bool redemptionConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory instrument, string memory platform, bool redemptionConfirmed) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(RedemptionPulse(instrument, platform, redemptionConfirmed, block.timestamp));
        emit RedemptionPulseEmitted(instrument, platform, redemptionConfirmed, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, uint256) {
        RedemptionPulse memory p = pulses[index];
        return (p.instrument, p.platform, p.redemptionConfirmed, p.timestamp);
    }
}
