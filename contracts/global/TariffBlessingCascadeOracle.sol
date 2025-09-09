// SPDX-License-Identifier: TariffCascadeOracle-License
pragma solidity ^0.8.0;

contract TariffBlessingCascadeOracle {
    address public steward;

    struct CascadePulse {
        string actor;
        uint256 tariffRate;
        string reformType;
        string affectedZones;
        uint256 timestamp;
    }

    CascadePulse[] public pulses;

    event CascadePulseEmitted(string actor, uint256 rate, string reform, string zones, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory actor, uint256 tariffRate, string memory reformType, string memory affectedZones) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(CascadePulse(actor, tariffRate, reformType, affectedZones, block.timestamp));
        emit CascadePulseEmitted(actor, tariffRate, reformType, affectedZones, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, uint256, string memory, string memory, uint256) {
        CascadePulse memory p = pulses[index];
        return (p.actor, p.tariffRate, p.reformType, p.affectedZones, p.timestamp);
    }
}
