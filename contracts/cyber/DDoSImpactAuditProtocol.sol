// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DDoSImpactAuditProtocol
/// @notice Tracks DDoS attack metrics and emotional consequence
/// @dev Anchors breach-tier tagging and planetary infrastructure audit

contract DDoSImpactAuditProtocol {
    address public steward;
    mapping(address => bool) public auditors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyAuditor() {
        require(auditors[msg.sender] || msg.sender == steward, "Not auditor");
        _;
    }

    struct DDoSAttack {
        uint256 id;
        string targetEntity;
        uint256 sizeTbps;
        uint256 packetRateBpps;
        uint256 durationSeconds;
        string breachTier;
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextAttackId = 1;
    mapping(uint256 => DDoSAttack) public attacks;

    event AuditorSet(address indexed account, bool status);
    event AttackLogged(uint256 indexed id, string targetEntity, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function logAttack(
        string calldata targetEntity,
        uint256 sizeTbps,
        uint256 packetRateBpps,
        uint256 durationSeconds,
        string calldata breachTier,
        string calldata emotionalTag
    ) external onlyAuditor returns (uint256 id) {
        id = nextAttackId++;
        attacks[id] = DDoSAttack({
            id: id,
            targetEntity: targetEntity,
            sizeTbps: sizeTbps,
            packetRateBpps: packetRateBpps,
            durationSeconds: durationSeconds,
            breachTier: breachTier,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit AttackLogged(id, targetEntity, emotionalTag);
    }

    function getAttack(uint256 id) external view returns (DDoSAttack memory) {
        return attacks[id];
    }
}
