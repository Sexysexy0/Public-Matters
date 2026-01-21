pragma solidity ^0.8.20;

contract JudicialSuppressionProtocol {
    address public admin;

    struct Suppression {
        string domain;       // e.g. courts, government systems
        string action;       // e.g. restrictions, rulings against faith, censorship
        uint256 timestamp;
    }

    Suppression[] public suppressions;

    event SuppressionLogged(string domain, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSuppression(string calldata domain, string calldata action) external onlyAdmin {
        suppressions.push(Suppression(domain, action, block.timestamp));
        emit SuppressionLogged(domain, action, block.timestamp);
    }

    function totalSuppressions() external view returns (uint256) {
        return suppressions.length;
    }
}
