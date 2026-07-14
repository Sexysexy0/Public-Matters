// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Evidence Chain Oracle
/// @notice Encodes safeguard for immutable, traceable evidence across governance layers.
/// @dev Complements TruthMandala, LeadershipAccountabilityMandala, TransparencyMandala, and BureaucraticAccountability.

contract EvidenceChainOracle {
    address public guardian;
    uint256 public evidenceCount;
    uint256 public councilCount;

    enum EvidenceRule {
        EvidenceIsConstitutional,
        EvidenceImmutable,
        EvidenceTraceable,
        SuppressionProhibited,
        PublicBenefitPriority
    }

    enum EvidenceStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EvidenceConfirmed
    }

    struct Rule {
        uint256 id;
        EvidenceRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct EvidenceCase {
        uint256 id;
        address proposer;
        string referenceHash;   // e.g. IPFS hash or off-chain doc ID
        string grounds;
        EvidenceStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => EvidenceCase) public evidenceCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EvidenceRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EvidenceFiled(uint256 indexed id, string referenceHash);
    event EvidenceStatusChanged(uint256 indexed id, EvidenceStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        evidenceCount = 0;
        councilCount = 0;
        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMember[msg.sender], "Council only");
        _;
    }

    function addCouncilMember(address member) external onlyGuardian {
        require(!councilMember[member], "Already council");
        councilMember[member] = true;
        councilCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(councilMember[member], "Not council");
        councilMember[member] = false;
        councilCount--;
        emit CouncilMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declare(EvidenceRule.EvidenceIsConstitutional, "Evidence is constitutional; denial prohibited.");
        _declare(EvidenceRule.EvidenceImmutable, "Evidence entries are immutable once filed.");
        _declare(EvidenceRule.EvidenceTraceable, "Evidence must be traceable across governance layers.");
        _declare(EvidenceRule.SuppressionProhibited, "Suppression of evidence is prohibited.");
        _declare(EvidenceRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(EvidenceRule ruleType, string memory description) internal {
        evidenceCount++;
        rules[evidenceCount] = Rule(
            evidenceCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(evidenceCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileEvidenceCase(
        string calldata referenceHash,
        string calldata grounds
    ) external {
        evidenceCount++;
        evidenceCases[evidenceCount] = EvidenceCase(
            evidenceCount,
            msg.sender,
            referenceHash,
            grounds,
            EvidenceStatus.Filed,
            0,
            block.timestamp
        );

        emit EvidenceFiled(evidenceCount, referenceHash);
    }

    function beginReview(uint256 evidenceId) external onlyCouncil {
        EvidenceCase storage e = evidenceCases[evidenceId];
        require(e.status == EvidenceStatus.Filed, "Not filed");
        e.status = EvidenceStatus.UnderReview;
        emit EvidenceStatusChanged(evidenceId, EvidenceStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 evidenceId) external onlyCouncil {
        EvidenceCase storage e = evidenceCases[evidenceId];
        require(e.status == EvidenceStatus.UnderReview, "Not under review");
        e.status = EvidenceStatus.MultiCouncilReview;
        emit EvidenceStatusChanged(evidenceId, EvidenceStatus.MultiCouncilReview);
    }

    function confirmEvidence(uint256 evidenceId) external onlyCouncil {
        EvidenceCase storage e = evidenceCases[evidenceId];
        require(e.status == EvidenceStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EvidenceStatus.EvidenceConfirmed;
            emit EvidenceStatusChanged(evidenceId, EvidenceStatus.EvidenceConfirmed);
        }
    }

    function rejectEvidence(uint256 evidenceId) external onlyCouncil {
        EvidenceCase storage e = evidenceCases[evidenceId];
        require(
            e.status == EvidenceStatus.Filed ||
            e.status == EvidenceStatus.UnderReview ||
            e.status == EvidenceStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EvidenceStatus.Rejected;
        emit EvidenceStatusChanged(evidenceId, EvidenceStatus.Rejected);
    }
}
