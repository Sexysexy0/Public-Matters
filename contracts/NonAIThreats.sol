// contracts/NonAIThreats.sol
pragma solidity ^0.8.20;

/**
 * @title NonAIThreats
 * @notice Logs traditional cyber threats (misconfigurations, insider threats, outdated systems).
 */
contract NonAIThreats {
    address public admin;

    struct Threat {
        string type;        // "CloudMisconfig", "Insider", "LegacySystem"
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
