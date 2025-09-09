// SPDX-License-Identifier: CannabisReschedulingOracle-License
pragma solidity ^0.8.0;

contract CannabisReschedulingOracle {
    address public steward;

    struct RescheduleEvent {
        string jurisdiction;
        string reformType;
        string rippleZone;
        bool mercyClauseActivated;
        uint256 timestamp;
    }

    RescheduleEvent[] public events;

    event ReschedulePulseEmitted(string jurisdiction, string reform, string zone, bool mercy, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory jurisdiction, string memory reformType, string memory rippleZone, bool mercyClauseActivated) public {
        require(msg.sender == steward, "Only steward can emit");
        events.push(RescheduleEvent(jurisdiction, reformType, rippleZone, mercyClauseActivated, block.timestamp));
        emit ReschedulePulseEmitted(jurisdiction, reformType, rippleZone, mercyClauseActivated, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        RescheduleEvent memory e = events[index];
        return (e.jurisdiction, e.reformType, e.rippleZone, e.mercyClauseActivated, e.timestamp);
    }
}
