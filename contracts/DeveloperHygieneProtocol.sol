pragma solidity ^0.8.20;

contract DeveloperHygieneProtocol {
    address public admin;

    struct Hygiene {
        string practice;     // e.g. hardcoding secrets, unused endpoints
        string severity;     // e.g. poor, dangerous
        string consequence;  // e.g. noise for defenders, attack surface
        uint256 timestamp;
    }

    Hygiene[] public hygieneRecords;

    event HygieneLogged(string practice, string severity, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHygiene(string calldata practice, string calldata severity, string calldata consequence) external onlyAdmin {
        hygieneRecords.push(Hygiene(practice, severity, consequence, block.timestamp));
        emit HygieneLogged(practice, severity, consequence, block.timestamp);
    }

    function totalHygieneRecords() external view returns (uint256) {
        return hygieneRecords.length;
    }
}
