pragma solidity ^0.8.20;

contract ImmigrationAccountabilityProtocol {
    address public admin;

    struct Accountability {
        string agency;       // e.g. Bureau of Immigration
        string complaint;    // e.g. arbitrary offloading
        string demand;       // e.g. transparency, reform
        uint256 timestamp;
    }

    Accountability[] public accountabilities;

    event AccountabilityLogged(string agency, string complaint, string demand, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAccountability(string calldata agency, string calldata complaint, string calldata demand) external onlyAdmin {
        accountabilities.push(Accountability(agency, complaint, demand, block.timestamp));
        emit AccountabilityLogged(agency, complaint, demand, block.timestamp);
    }

    function totalAccountabilities() external view returns (uint256) {
        return accountabilities.length;
    }
}
