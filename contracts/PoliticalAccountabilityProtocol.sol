pragma solidity ^0.8.20;

contract PoliticalAccountabilityProtocol {
    address public admin;

    struct Accountability {
        string leader;       // e.g. Senator Camille Villar
        string mandate;      // e.g. Committee on Environment
        string expectation;  // e.g. hearings, representation
        uint256 timestamp;
    }

    Accountability[] public accountabilities;

    event AccountabilityLogged(string leader, string mandate, string expectation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAccountability(string calldata leader, string calldata mandate, string calldata expectation) external onlyAdmin {
        accountabilities.push(Accountability(leader, mandate, expectation, block.timestamp));
        emit AccountabilityLogged(leader, mandate, expectation, block.timestamp);
    }

    function totalAccountabilities() external view returns (uint256) {
        return accountabilities.length;
    }
}
