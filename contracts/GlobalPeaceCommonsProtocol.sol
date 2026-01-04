pragma solidity ^0.8.20;

contract GlobalPeaceCommonsProtocol {
    address public admin;

    struct Initiative {
        string region;       // e.g. Middle East, Asia-Pacific
        string action;       // e.g. ceasefire, treaty, dialogue
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string region, string action, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInitiative(string calldata region, string calldata action) external onlyAdmin {
        initiatives.push(Initiative(region, action, block.timestamp));
        emit InitiativeLogged(region, action, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) {
        return initiatives.length;
    }
}
