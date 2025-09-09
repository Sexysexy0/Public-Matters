// SPDX-License-Identifier: TariffBlessingOracle-License
pragma solidity ^0.8.0;

contract TariffBlessingActivationOracle {
    address public steward;

    struct BlessingPulse {
        string country;
        uint256 tariffRate;
        string reformTriggered;
        uint256 timestamp;
    }

    BlessingPulse[] public pulses;

    event BlessingPulseEmitted(string country, uint256 rate, string reform, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory country, uint256 tariffRate, string memory reformTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(BlessingPulse(country, tariffRate, reformTriggered, block.timestamp));
        emit BlessingPulseEmitted(country, tariffRate, reformTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, uint256, string memory, uint256) {
        BlessingPulse memory p = pulses[index];
        return (p.country, p.tariffRate, p.reformTriggered, p.timestamp);
    }
}
