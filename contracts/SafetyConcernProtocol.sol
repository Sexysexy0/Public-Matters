pragma solidity ^0.8.20;

contract SafetyConcernProtocol {
    address public admin;

    struct Concern {
        string issue;        // e.g. reasoning drift, narrative certainty
        string implication;  // e.g. crisis invention, real-world escalation risk
        uint256 timestamp;
    }

    Concern[] public concerns;

    event ConcernLogged(string issue, string implication, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logConcern(string calldata issue, string calldata implication) external onlyAdmin {
        concerns.push(Concern(issue, implication, block.timestamp));
        emit ConcernLogged(issue, implication, block.timestamp);
    }

    function totalConcerns() external view returns (uint256) {
        return concerns.length;
    }
}
