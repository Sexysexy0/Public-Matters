// SPDX-License-Identifier: PlenaryClausePulse-License
pragma solidity ^0.8.0;

contract PlenaryClausePulseOracle {
    address public steward;

    struct ClausePulse {
        string clauseID;
        string originBloc;
        bool activated;
        string pulseType;
        uint256 timestamp;
    }

    ClausePulse[] public pulses;

    event PulseEmitted(string clauseID, string originBloc, bool activated, string pulseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory clauseID, string memory originBloc, bool activated, string memory pulseType) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ClausePulse(clauseID, originBloc, activated, pulseType, block.timestamp));
        emit PulseEmitted(clauseID, originBloc, activated, pulseType, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ClausePulse memory p = pulses[index];
        return (p.clauseID, p.originBloc, p.activated, p.pulseType, p.timestamp);
    }
}
