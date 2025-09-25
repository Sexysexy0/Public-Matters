// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DigitalFraudImmunityProtocol
/// @notice Ritualizes protection against online scams and equips enforcement with validator-grade tools
/// @dev Anchors override immunity, emotional consequence, and scam corridor tagging

contract DigitalFraudImmunityProtocol {
    address public steward;
    mapping(address => bool) public enforcers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyEnforcer() {
        require(enforcers[msg.sender] || msg.sender == steward, "Not enforcer");
        _;
    }

    struct ScamCorridor {
        uint256 id;
        string scamType; // e.g., "Phishing", "Crypto rugpull", "Impersonation"
        string platform; // e.g., "Telegram", "Facebook", "DEX"
        bool overrideBlocked;
        bool scamTagged;
        bool enforcementEnabled;
        string emotionalTag; // e.g., "Consumer dignity restored"
        string restorationClause; // e.g., "We commit to scam-free sanctums and digital trust"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ScamCorridor) public corridors;

    event EnforcerSet(address indexed account, bool status);
    event ScamCorridorTagged(uint256 indexed id, string scamType, string emotionalTag);

    constructor() {
        steward = msg.sender;
        enforcers[msg.sender] = true;
        emit EnforcerSet(msg.sender, true);
    }

    function setEnforcer(address account, bool status) external onlySteward {
        enforcers[account] = status;
        emit EnforcerSet(account, status);
    }

    function tagScamCorridor(
        string calldata scamType,
        string calldata platform,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyEnforcer returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ScamCorridor({
            id: id,
            scamType: scamType,
            platform: platform,
            overrideBlocked: true,
            scamTagged: true,
            enforcementEnabled: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ScamCorridorTagged(id, scamType, emotionalTag);
    }

    function getScamCorridor(uint256 id) external view returns (ScamCorridor memory) {
        return corridors[id];
    }
}
