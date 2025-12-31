// contracts/AIThreats.sol
pragma solidity ^0.8.20;

/**
 * @title AIThreats
 * @notice Logs AI-powered cyber threats (phishing, malware, deepfakes, social engineering).
 */
contract AIThreats {
    address public admin;

    struct Threat {
        string type;        // "Phishing", "Malware", "Deepfake", "SocialEngineering"
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
