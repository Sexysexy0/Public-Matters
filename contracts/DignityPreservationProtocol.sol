pragma solidity ^0.8.20;

contract DignityPreservationProtocol {
    address public admin;

    struct Preservation {
        string action;       // e.g. restrict, audit, remove
        string outcome;      // e.g. dignity preserved, community safe
        uint256 timestamp;
    }

    Preservation[] public preservations;

    event PreservationLogged(string action, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPreservation(string calldata action, string calldata outcome) external onlyAdmin {
        preservations.push(Preservation(action, outcome, block.timestamp));
        emit PreservationLogged(action, outcome, block.timestamp);
    }

    function totalPreservations() external view returns (uint256) {
        return preservations.length;
    }
}
