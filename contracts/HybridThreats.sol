// contracts/HybridThreats.sol
pragma solidity ^0.8.20;

/**
 * @title HybridThreats
 * @notice Logs hybrid risks that may evolve into AI-driven threats.
 */
contract HybridThreats {
    address public admin;

    struct Threat {
        string type;        // "Ransomware", "SupplyChain", "Botnet"
        string description;
        uint256 timestamp;
    }

    Threat[] public threats;

    event ThreatLogged(string type, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logThreat(string calldata type, string calldata description) external onlyAdmin {
        threats.push(Threat(type, description, block.timestamp));
        emit ThreatLogged(type, description, block.timestamp);
    }
}
