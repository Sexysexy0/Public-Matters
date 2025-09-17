// SPDX-License-Identifier: SovereigntySanctum
pragma solidity ^0.8.19;

contract AntitrustSignalRouter {
    address public steward;

    struct AntitrustEvent {
        string company;
        string jurisdiction;
        string triggerDeal;
        string conditionViolated;
        uint256 timestamp;
        bool resolved;
    }

    AntitrustEvent[] public events;

    event AntitrustLogged(string company, string jurisdiction, string triggerDeal, string conditionViolated, uint256 timestamp);
    event ResolutionUpdated(uint256 index, bool resolved);

    constructor() {
        steward = msg.sender;
    }

    function logAntitrustEvent(
        string memory company,
        string memory jurisdiction,
        string memory triggerDeal,
        string memory conditionViolated
    ) public {
        events.push(AntitrustEvent(company, jurisdiction, triggerDeal, conditionViolated, block.timestamp, false));
        emit AntitrustLogged(company, jurisdiction, triggerDeal, conditionViolated, block.timestamp);
    }

    function updateResolutionStatus(uint256 index, bool status) public {
        require(index < events.length, "Invalid index");
        events[index].resolved = status;
        emit ResolutionUpdated(index, status);
    }

    function getAntitrustEvent(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256, bool
    ) {
        AntitrustEvent memory e = events[index];
        return (e.company, e.jurisdiction, e.triggerDeal, e.conditionViolated, e.timestamp, e.resolved);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}
