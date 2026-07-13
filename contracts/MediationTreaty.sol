// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Mediation Treaty
/// @notice Encodes voluntary mediation safeguard.
/// @dev Complements EducationalMaterialsFramework, ICANNContributionMandala, and ComplaintWithdrawalTreaty.

contract MediationTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public councilCount;

    enum MediationRule {
        MediationIsConstitutional,
        VoluntaryOnly,
        ForcedMediationBlocked,
        ProviderFrameworkEnabled,
        TransparencyInMediationSystems,
        PublicBenefitPriority
    }

    enum MediationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        MediationConfirmed
    }

    struct Rule {
        uint256 id;
        MediationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Mediation {
        uint256 id;
        address proposer;
        string caseReference;
        string grounds;
        MediationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Mediation) public mediations;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, MediationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event MediationFiled(uint256 indexed id, string caseReference);
    event MediationStatusChanged(uint256 indexed id, MediationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        treatyCount = 0;
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
        _declare(MediationRule.MediationIsConstitutional, "Mediation is constitutional; denial prohibited.");
        _declare(MediationRule.VoluntaryOnly, "Voluntary only; forced mediation blocked.");
        _declare(MediationRule.ForcedMediationBlocked, "Forced mediation blocked; fairness required.");
        _declare(MediationRule.ProviderFrameworkEnabled, "Provider framework enabled; optional mediation allowed.");
        _declare(MediationRule.TransparencyInMediationSystems, "Mediation systems must be transparent.");
        _declare(MediationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(MediationRule ruleType, string memory description) internal {
        treatyCount++;
        rules[treatyCount] = Rule(
            treatyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(treatyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileMediation(
        string calldata caseReference,
        string calldata grounds
    ) external {
        treatyCount++;
        mediations[treatyCount] = Mediation(
            treatyCount,
            msg.sender,
            caseReference,
            grounds,
            MediationStatus.Filed,
            0,
            block.timestamp
        );

        emit MediationFiled(treatyCount, caseReference);
    }

    function beginReview(uint256 mediationId) external onlyCouncil {
        Mediation storage m = mediations[mediationId];
        require(m.status == MediationStatus.Filed, "Not filed");
        m.status = MediationStatus.UnderReview;
        emit MediationStatusChanged(mediationId, MediationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 mediationId) external onlyCouncil {
        Mediation storage m = mediations[mediationId];
        require(m.status == MediationStatus.UnderReview, "Not under review");
        m.status = MediationStatus.MultiCouncilReview;
        emit MediationStatusChanged(mediationId, MediationStatus.MultiCouncilReview);
    }

    function confirmMediation(uint256 mediationId) external onlyCouncil {
        Mediation storage m = mediations[mediationId];
        require(m.status == MediationStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = MediationStatus.MediationConfirmed;
            emit MediationStatusChanged(mediationId, MediationStatus.MediationConfirmed);
        }
    }

    function rejectMediation(uint256 mediationId) external onlyCouncil {
        Mediation storage m = mediations[mediationId];
        require(
            m.status == MediationStatus.Filed ||
            m.status == MediationStatus.UnderReview ||
            m.status == MediationStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = MediationStatus.Rejected;
        emit MediationStatusChanged(mediationId, MediationStatus.Rejected);
    }
}
