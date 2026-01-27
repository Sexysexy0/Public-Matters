pragma solidity ^0.8.20;

contract EnvironmentalSecurityProtocol {
    address public admin;

    struct Security {
        string issue;        // e.g. nuclear isotope drift
        string measure;      // e.g. surveillance, cooperation
        string goal;         // e.g. safeguard ecosystems, protect communities
        uint256 timestamp;
    }

    Security[] public securities;

    event SecurityLogged(string issue, string measure, string goal, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSecurity(string calldata issue, string calldata measure, string calldata goal) external onlyAdmin {
        securities.push(Security(issue, measure, goal, block.timestamp));
        emit SecurityLogged(issue, measure, goal, block.timestamp);
    }

    function totalSecurities() external view returns (uint256) {
        return securities.length;
    }
}
