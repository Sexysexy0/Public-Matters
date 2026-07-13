// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Name Redaction Framework
/// @notice Encodes name redaction safeguard.
/// @dev Complements MediationTreaty, EducationalMaterialsFramework, and RegistrarNoticeMandala.

contract NameRedactionFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public councilCount;

    enum RedactionRule {
        RedactionIsConstitutional,
        PrivacyProtected,
        DisclosureSuppressed,
        TransparencyInRedactionSystems,
        PublicBenefitPriority
    }

    enum RedactionStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        RedactionConfirmed
    }

    struct Rule {
        uint256 id;
        RedactionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Redaction {
        uint256 id;
        address requester;
        string caseReference;
        string grounds;
        RedactionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Redaction) public redactions;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RedactionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event RedactionFiled(uint256 indexed id, string caseReference);
    event RedactionStatusChanged(uint256 indexed id, RedactionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        frameworkCount = 0;
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
        _declare(RedactionRule.RedactionIsConstitutional, "Redaction is constitutional; denial prohibited.");
        _declare(RedactionRule.PrivacyProtected, "Privacy protected; unnecessary disclosure blocked.");
        _declare(RedactionRule.DisclosureSuppressed, "Disclosure suppressed; fairness required.");
        _declare(RedactionRule.TransparencyInRedactionSystems, "Redaction systems must be transparent.");
        _declare(RedactionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(RedactionRule ruleType, string memory description) internal {
        frameworkCount++;
        rules[frameworkCount] = Rule(
            frameworkCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(frameworkCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileRedaction(
        string calldata caseReference,
        string calldata grounds
    ) external {
        frameworkCount++;
        redactions[frameworkCount] = Redaction(
            frameworkCount,
            msg.sender,
            caseReference,
            grounds,
            RedactionStatus.Filed,
            0,
            block.timestamp
        );

        emit RedactionFiled(frameworkCount, caseReference);
    }

    function beginReview(uint256 redactionId) external onlyCouncil {
        Redaction storage r = redactions[redactionId];
        require(r.status == RedactionStatus.Filed, "Not filed");
        r.status = RedactionStatus.UnderReview;
        emit RedactionStatusChanged(redactionId, RedactionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 redactionId) external onlyCouncil {
        Redaction storage r = redactions[redactionId];
        require(r.status == RedactionStatus.UnderReview, "Not under review");
        r.status = RedactionStatus.MultiCouncilReview;
        emit RedactionStatusChanged(redactionId, RedactionStatus.MultiCouncilReview);
    }

    function confirmRedaction(uint256 redactionId) external onlyCouncil {
        Redaction storage r = redactions[redactionId];
        require(r.status == RedactionStatus.MultiCouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = RedactionStatus.RedactionConfirmed;
            emit RedactionStatusChanged(redactionId, RedactionStatus.RedactionConfirmed);
        }
    }

    function rejectRedaction(uint256 redactionId) external onlyCouncil {
        Redaction storage r = redactions[redactionId];
        require(
            r.status == RedactionStatus.Filed ||
            r.status == RedactionStatus.UnderReview ||
            r.status == RedactionStatus.MultiCouncilReview,
            "Invalid status"
        );
        r.status = RedactionStatus.Rejected;
        emit RedactionStatusChanged(redactionId, RedactionStatus.Rejected);
    }
}
