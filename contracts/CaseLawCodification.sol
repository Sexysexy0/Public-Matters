// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Case Law Codification
/// @notice Encodes pan-provider jurisprudence safeguard.
/// @dev Complements ExpeditedProcedureFramework, AppealsMandala, and PanelistQuality.

contract CaseLawCodification {
    address public guardian;
    uint256 public codexCount;
    uint256 public councilCount;

    enum JurisRule {
        JurisprudenceIsConstitutional,
        PrecedentMandated,
        InconsistencySuppressed,
        TransparencyInJurisSystems,
        PublicBenefitPriority
    }

    enum JurisStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        JurisConfirmed
    }

    struct Rule {
        uint256 id;
        JurisRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct JurisCase {
        uint256 id;
        address proposer;
        string grounds;
        JurisStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => JurisCase) public jurisprudence;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, JurisRule ruleType);
    event RuleLocked(uint256 indexed id);
    event JurisFiled(uint256 indexed id);
    event JurisStatusChanged(uint256 indexed id, JurisStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        codexCount = 0;
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
        _declare(JurisRule.JurisprudenceIsConstitutional, "Jurisprudence is constitutional; denial prohibited.");
        _declare(JurisRule.PrecedentMandated, "Precedent mandated; inconsistency blocked.");
        _declare(JurisRule.InconsistencySuppressed, "Inconsistency suppressed; fairness required.");
        _declare(JurisRule.TransparencyInJurisSystems, "Jurisprudence systems must be transparent.");
        _declare(JurisRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(JurisRule ruleType, string memory description) internal {
        codexCount++;
        rules[codexCount] = Rule(
            codexCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(codexCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileJurisCase(string calldata grounds) external {
        codexCount++;
        jurisprudence[codexCount] = JurisCase(
            codexCount,
            msg.sender,
            grounds,
            JurisStatus.Filed,
            0,
            block.timestamp
        );

        emit JurisFiled(codexCount);
    }

    function beginReview(uint256 jurisId) external onlyCouncil {
        JurisCase storage j = jurisprudence[jurisId];
        require(j.status == JurisStatus.Filed, "Not filed");
        j.status = JurisStatus.UnderReview;
        emit JurisStatusChanged(jurisId, JurisStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 jurisId) external onlyCouncil {
        JurisCase storage j = jurisprudence[jurisId];
        require(j.status == JurisStatus.UnderReview, "Not under review");
        j.status = JurisStatus.MultiCouncilReview;
        emit JurisStatusChanged(jurisId, JurisStatus.MultiCouncilReview);
    }

    function confirmJuris(uint256 jurisId) external onlyCouncil {
        JurisCase storage j = jurisprudence[jurisId];
        require(j.status == JurisStatus.MultiCouncilReview, "Not in council stage");

        j.approvals++;

        if (j.approvals * 2 > councilCount && councilCount > 0) {
            j.status = JurisStatus.JurisConfirmed;
            emit JurisStatusChanged(jurisId, JurisStatus.JurisConfirmed);
        }
    }

    function rejectJuris(uint256 jurisId) external onlyCouncil {
        JurisCase storage j = jurisprudence[jurisId];
        require(
            j.status == JurisStatus.Filed ||
            j.status == JurisStatus.UnderReview ||
            j.status == JurisStatus.MultiCouncilReview,
            "Invalid status"
        );
        j.status = JurisStatus.Rejected;
        emit JurisStatusChanged(jurisId, JurisStatus.Rejected);
    }
}
