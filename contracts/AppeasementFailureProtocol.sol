pragma solidity ^0.8.20;

contract AppeasementFailureProtocol {
    address public admin;

    struct Failure {
        string policy;       // e.g. appeasement on tariffs
        string consequence;  // e.g. emboldened bullying, weakened alliances
        string alternative;  // e.g. unified European stance
        uint256 timestamp;
    }

    Failure[] public failures;

    event FailureLogged(string policy, string consequence, string alternative, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFailure(string calldata policy, string calldata consequence, string calldata alternative) external onlyAdmin {
        failures.push(Failure(policy, consequence, alternative, block.timestamp));
        emit FailureLogged(policy, consequence, alternative, block.timestamp);
    }

    function totalFailures() external view returns (uint256) {
        return failures.length;
    }
}
