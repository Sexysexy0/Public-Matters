pragma solidity ^0.8.20;

contract FedIndependenceProtocol {
    address public admin;

    struct IndependenceEvent {
        string action;       // e.g. investigation, removal attempt
        string risk;         // e.g. loss of trust, dollar decline
        uint256 timestamp;
    }

    IndependenceEvent[] public events;

    event IndependenceLogged(string action, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIndependence(string calldata action, string calldata risk) external onlyAdmin {
        events.push(IndependenceEvent(action, risk, block.timestamp));
        emit IndependenceLogged(action, risk, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }
}
