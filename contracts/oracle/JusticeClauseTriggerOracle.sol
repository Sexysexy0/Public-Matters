// SPDX-License-Identifier: JusticeClause-License
pragma solidity ^0.8.0;

contract JusticeClauseTriggerOracle {
    address public steward;

    struct ReformPulse {
        string clause;
        string verdictType;
        string civicRipple;
        uint256 timestamp;
    }

    ReformPulse[] public pulses;

    event JusticeClauseTriggered(string clause, string verdictType, string ripple, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitClauseTrigger(string memory clause, string memory verdictType, string memory civicRipple) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ReformPulse(clause, verdictType, civicRipple, block.timestamp));
        emit JusticeClauseTriggered(clause, verdictType, civicRipple, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, uint256) {
        ReformPulse memory p = pulses[index];
        return (p.clause, p.verdictType, p.civicRipple, p.timestamp);
    }

    function totalPulses() public view returns (uint) {
        return pulses.length;
    }
}
