// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GovPartnerIntegrityProtocol
/// @notice Verifies integrity of government contractors and emits trust restoration events
/// @dev Anchors audit-grade transparency and emotional consequence

contract GovPartnerIntegrityProtocol {
    address public steward;
    mapping(address => bool) public verifiers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyVerifier() {
        require(verifiers[msg.sender] || msg.sender == steward, "Not verifier");
        _;
    }

    struct PartnerAudit {
        uint256 id;
        string entity;
        string agency; // e.g., "DARPA", "NASA", "DoW"
        bool verified;
        string emotionalTag;
        uint256 timestamp;
    }

    uint256 public nextAuditId = 1;
    mapping(uint256 => PartnerAudit) public audits;

    event VerifierSet(address indexed account, bool status);
    event PartnerVerified(uint256 indexed id, string entity, string agency, bool verified, string emotionalTag);

    constructor() {
        steward = msg.sender;
        verifiers[msg.sender] = true;
        emit VerifierSet(msg.sender, true);
    }

    function setVerifier(address account, bool status) external onlySteward {
        verifiers[account] = status;
        emit VerifierSet(account, status);
    }

    function verifyPartner(string calldata entity, string calldata agency, bool verified, string calldata emotionalTag) external onlyVerifier returns (uint256 id) {
        id = nextAuditId++;
        audits[id] = PartnerAudit({
            id: id,
            entity: entity,
            agency: agency,
            verified: verified,
            emotionalTag: emotionalTag,
            timestamp: block.timestamp
        });
        emit PartnerVerified(id, entity, agency, verified, emotionalTag);
    }

    function getAudit(uint256 id) external view returns (PartnerAudit memory) {
        return audits[id];
    }
}
