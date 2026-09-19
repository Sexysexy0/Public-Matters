// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title InvestigatorShield
 * @notice Protection framework for independent investigators and
 *         whistleblowers exposing institutional fraud.
 *
 *         Directly addresses: AB2624 ("Stop Nick Shirley Act") pattern,
 *         California HSR investigation (2026-09-20).
 */
contract InvestigatorShield {
    OperatorPrivilegesV2 public privileges;

    struct Investigator {
        address addr;
        bytes32 publicKeyHash;   // ZK-commitment for anonymity
        string jurisdiction;
        uint256 registeredAt;
        bool active;
        uint256 reportsSubmitted;
    }

    struct EvidenceSubmission {
        uint256 id;
        address investigator;
        bytes32 evidenceHash;
        bytes32 targetInstitution;
        string category;
        uint256 timestamp;
        bool verified;
    }

    struct SuppressionLaw {
        bytes32 lawId;
        string jurisdiction;
        string description;
        uint256 recordedAt;
        bool active;
    }

    uint256 public investigatorCount;
    uint256 public evidenceCount;
    uint256 public suppressionLawCount;

    mapping(address => Investigator) internal _investigators;
    mapping(uint256 => EvidenceSubmission) internal _evidence;
    mapping(uint256 => SuppressionLaw) internal _suppressionLaws;
    mapping(address => uint256[]) internal _evidenceByInvestigator;

    event InvestigatorRegistered(address indexed addr, string jurisdiction);
    event InvestigatorDeregistered(address indexed addr, bytes32 reason);
    event EvidenceSubmitted(uint256 indexed id, address indexed investigator, bytes32 targetInstitution, string category);
    event EvidenceVerified(uint256 indexed id, address verifier);
    event SuppressionLawRecorded(uint256 indexed id, bytes32 lawId, string jurisdiction, string description);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── INVESTIGATOR REGISTRATION ───

    function registerInvestigator(
        address addr,
        bytes32 publicKeyHash,
        string calldata jurisdiction
    ) external onlyOperator {
        require(addr != address(0), "Invalid address");
        require(publicKeyHash != bytes32(0), "Public key hash required");
        require(!_investigators[addr].active, "Already registered");

        _investigators[addr] = Investigator({
            addr: addr,
            publicKeyHash: publicKeyHash,
            jurisdiction: jurisdiction,
            registeredAt: block.timestamp,
            active: true,
            reportsSubmitted: 0
        });

        investigatorCount++;

        emit InvestigatorRegistered(addr, jurisdiction);
    }

    function deregisterInvestigator(address addr, bytes32 reason) external onlyOperator {
        require(_investigators[addr].active, "Not active");
        _investigators[addr].active = false;
        investigatorCount--;

        emit InvestigatorDeregistered(addr, reason);
    }

    // ─── EVIDENCE SUBMISSION ───

    function submitEvidence(
        bytes32 evidenceHash,
        bytes32 targetInstitution,
        string calldata category
    ) external returns (uint256) {
        require(evidenceHash != bytes32(0), "Evidence hash required");
        require(targetInstitution != bytes32(0), "Target required");
        require(_investigators[msg.sender].active, "Investigator not registered");

        evidenceCount++;
        uint256 id = evidenceCount;

        _evidence[id] = EvidenceSubmission({
            id: id,
            investigator: msg.sender,
            evidenceHash: evidenceHash,
            targetInstitution: targetInstitution,
            category: category,
            timestamp: block.timestamp,
            verified: false
        });

        _evidenceByInvestigator[msg.sender].push(id);
        _investigators[msg.sender].reportsSubmitted++;

        emit EvidenceSubmitted(id, msg.sender, targetInstitution, category);
        return id;
    }

    function verifyEvidence(uint256 id) external onlyOperator {
        require(_evidence[id].id != 0, "Evidence not found");
        require(!_evidence[id].verified, "Already verified");

        _evidence[id].verified = true;
        emit EvidenceVerified(id, msg.sender);
    }

    // ─── SUPPRESSION LAW TRACKING ───

    function recordSuppressionLaw(
        bytes32 lawId,
        string calldata jurisdiction,
        string calldata description
    ) external onlyOperator returns (uint256) {
        require(lawId != bytes32(0), "Law ID required");

        suppressionLawCount++;
        uint256 id = suppressionLawCount;

        _suppressionLaws[id] = SuppressionLaw({
            lawId: lawId,
            jurisdiction: jurisdiction,
            description: description,
            recordedAt: block.timestamp,
            active: true
        });

        emit SuppressionLawRecorded(id, lawId, jurisdiction, description);
        return id;
    }

    // ─── VIEWS ───

    function getInvestigator(address addr) external view returns (Investigator memory) {
        return _investigators[addr];
    }

    function isInvestigatorActive(address addr) external view returns (bool) {
        return _investigators[addr].active;
    }

    function getEvidence(uint256 id) external view returns (EvidenceSubmission memory) {
        return _evidence[id];
    }

    function getEvidenceByInvestigator(address addr) external view returns (uint256[] memory) {
        return _evidenceByInvestigator[addr];
    }

    function getSuppressionLaw(uint256 id) external view returns (SuppressionLaw memory) {
        return _suppressionLaws[id];
    }
}
