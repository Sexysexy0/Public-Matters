// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Remedy Cancellation
/// @notice Encodes true cancellation remedy safeguard.
/// @dev Complements AppealsMandala, JusticeMandala, and ResponsibilityMandala.

contract RemedyCancellation {
    address public guardian;
    uint256 public cancellationCount;
    uint256 public councilCount;

    enum CancellationRule {
        CancellationIsConstitutional,
        AbuseSuppressed,
        LegitimateReRegistrationEnabled,
        DueProcessProtected,
        PanelOversightRequired,
        PublicBenefitPriority,
        TransparencyInCancellationSystems
    }

    enum CancellationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CancellationGranted,
        CancellationDenied
    }

    struct Rule {
        uint256 id;
        CancellationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Cancellation {
        uint256 id;
        address complainant;
        address respondent;
        string domainName;
        string grounds;
        CancellationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Cancellation) public cancellations;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, CancellationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CancellationFiled(uint256 indexed id, string domainName);
    event CancellationStatusChanged(uint256 indexed id, CancellationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        cancellationCount = 0;
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
        _declare(CancellationRule.CancellationIsConstitutional, "Cancellation is constitutional; denial prohibited.");
        _declare(CancellationRule.AbuseSuppressed, "Abuse suppressed; cybersquatting blocked.");
        _declare(CancellationRule.LegitimateReRegistrationEnabled, "Legitimate re-registration enabled; fairness required.");
        _declare(CancellationRule.DueProcessProtected, "Due process protected; violation blocked.");
        _declare(CancellationRule.PanelOversightRequired, "Panel oversight required; collective governance.");
        _declare(CancellationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
        _declare(CancellationRule.TransparencyInCancellationSystems, "Cancellation systems must be transparent.");
    }

    function _declare(CancellationRule ruleType, string memory description) internal {
        uint256 id = cancellationCount + 1;
        rules[id] = Rule(id, ruleType, description, false, block.timestamp);
        emit RuleDeclared(id, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileCancellation(
        address respondent,
        string calldata domainName,
        string calldata grounds
    ) external {
        cancellationCount++;
        cancellations[cancellationCount] = Cancellation(
            cancellationCount,
            msg.sender,
            respondent,
            domainName,
            grounds,
            CancellationStatus.Filed,
            0,
            block.timestamp
        );

        emit CancellationFiled(cancellationCount, domainName);
    }

    function beginReview(uint256 cancellationId) external onlyCouncil {
        Cancellation storage c = cancellations[cancellationId];
        require(c.status == CancellationStatus.Filed, "Not filed");
        c.status = CancellationStatus.UnderReview;
        emit CancellationStatusChanged(cancellationId, CancellationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 cancellationId) external onlyCouncil {
        Cancellation storage c = cancellations[cancellationId];
        require(c.status == CancellationStatus.UnderReview, "Not under review");
        c.status = CancellationStatus.MultiCouncilReview;
        emit CancellationStatusChanged(cancellationId, CancellationStatus.MultiCouncilReview);
    }

    function grantCancellation(uint256 cancellationId) external onlyCouncil {
        Cancellation storage c = cancellations[cancellationId];
        require(c.status == CancellationStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CancellationStatus.CancellationGranted;
            emit CancellationStatusChanged(cancellationId, CancellationStatus.CancellationGranted);
        }
    }

    function denyCancellation(uint256 cancellationId) external onlyCouncil {
        Cancellation storage c = cancellations[cancellationId];
        require(
            c.status == CancellationStatus.Filed ||
            c.status == CancellationStatus.UnderReview ||
            c.status == CancellationStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CancellationStatus.CancellationDenied;
        emit CancellationStatusChanged(cancellationId, CancellationStatus.CancellationDenied);
    }
}
