// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CyberBreachAuditProtocol
/// @notice Tracks breach claims, confirms audit status, and emits emotional consequence
/// @dev Anchors validator-grade immunity and forensic trust

contract CyberBreachAuditProtocol {
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

    enum BreachStatus {
        Claimed,
        Denied,
        Confirmed,
        Unsubstantiated
    }

    struct BreachClaim {
        uint256 id;
        string targetEntity;
        string cartel;
        BreachStatus status;
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextClaimId = 1;
    mapping(uint256 => BreachClaim) public claims;

    event AuditorSet(address indexed account, bool status);
    event BreachLogged(uint256 indexed id, string targetEntity, string cartel, BreachStatus status, string emotionalTag);

    constructor() {
        steward = msg.sender;
        auditors[msg.sender] = true;
        emit AuditorSet(msg.sender, true);
    }

    function setAuditor(address account, bool status) external onlySteward {
        auditors[account] = status;
        emit AuditorSet(account, status);
    }

    function logBreach(string calldata targetEntity, string calldata cartel, BreachStatus status, string calldata emotionalTag) external onlyAuditor returns (uint256 id) {
        id = nextClaimId++;
        claims[id] = BreachClaim({
            id: id,
            targetEntity: targetEntity,
            cartel: cartel,
            status: status,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit BreachLogged(id, targetEntity, cartel, status, emotionalTag);
    }

    function getClaim(uint256 id) external view returns (BreachClaim memory) {
        return claims[id];
    }
}
