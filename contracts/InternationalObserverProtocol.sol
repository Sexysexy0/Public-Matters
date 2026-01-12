pragma solidity ^0.8.20;

contract InternationalObserverProtocol {
    address public admin;

    struct Observation {
        string body;         // e.g. UN, EU, communal auditors
        string event;        // e.g. election, protest, transition
        uint256 timestamp;
    }

    Observation[] public observations;

    event ObservationLogged(string body, string event, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logObservation(string calldata body, string calldata event) external onlyAdmin {
        observations.push(Observation(body, event, block.timestamp));
        emit ObservationLogged(body, event, block.timestamp);
    }

    function totalObservations() external view returns (uint256) {
        return observations.length;
    }
}
