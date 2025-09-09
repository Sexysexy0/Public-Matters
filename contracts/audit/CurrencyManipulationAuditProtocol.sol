// SPDX-License-Identifier: CurrencyAudit-License
pragma solidity ^0.8.0;

contract CurrencyManipulationAuditProtocol {
    address public steward;

    struct ManipulationEvent {
        string actor;
        string tokenName;
        string pivotType;
        bool deceptionDetected;
        string status;
        uint256 timestamp;
    }

    ManipulationEvent[] public events;

    event ManipulationLogged(string actor, string token, string pivot, bool deception, string status, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logManipulation(string memory actor, string memory tokenName, string memory pivotType, bool deceptionDetected) public {
        require(msg.sender == steward, "Only steward can log");
        string memory status = deceptionDetected ? "Blocked" : "Monitored";
        events.push(ManipulationEvent(actor, tokenName, pivotType, deceptionDetected, status, block.timestamp));
        emit ManipulationLogged(actor, tokenName, pivotType, deceptionDetected, status, block.timestamp);
    }

    function getEvent(uint index) public view returns (string memory, string memory, string memory, bool, string memory, uint256) {
        ManipulationEvent memory e = events[index];
        return (e.actor, e.tokenName, e.pivotType, e.deceptionDetected, e.status, e.timestamp);
    }
}
