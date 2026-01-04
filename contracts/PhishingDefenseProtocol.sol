pragma solidity ^0.8.20;

contract PhishingDefenseProtocol {
    address public admin;

    struct Attempt {
        string vector;       // e.g. email, SMS, fake site
        string status;       // e.g. blocked, reported, successful
        uint256 timestamp;
    }

    Attempt[] public attempts;

    event AttemptLogged(string vector, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAttempt(string calldata vector, string calldata status) external onlyAdmin {
        attempts.push(Attempt(vector, status, block.timestamp));
        emit AttemptLogged(vector, status, block.timestamp);
    }

    function totalAttempts() external view returns (uint256) {
        return attempts.length;
    }
}
