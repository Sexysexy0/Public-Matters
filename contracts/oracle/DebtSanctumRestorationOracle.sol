// SPDX-License-Identifier: DebtSanctumRestoration-License
pragma solidity ^0.8.0;

contract DebtSanctumRestorationOracle {
    address public steward;

    struct RestorationPulse {
        string sanctum;
        string clauseActivated;
        bool restorationConfirmed;
        uint256 timestamp;
    }

    RestorationPulse[] public pulses;

    event RestorationPulseEmitted(string sanctum, string clauseActivated, bool confirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory sanctum, string memory clauseActivated, bool restorationConfirmed) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(RestorationPulse(sanctum, clauseActivated, restorationConfirmed, block.timestamp));
        emit RestorationPulseEmitted(sanctum, clauseActivated, restorationConfirmed, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, uint256) {
        RestorationPulse memory p = pulses[index];
        return (p.sanctum, p.clauseActivated, p.restorationConfirmed, p.timestamp);
    }
}
