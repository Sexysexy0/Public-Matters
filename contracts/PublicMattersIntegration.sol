// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Public Matters Integration
/// @notice Integrates all innovation governance contracts into the Public Matters system.
/// @dev Acts as the kernel binding InnovationConstitution, FreedomCharter, MeritShield, BureaucraticAccountability,
///      TransparencyCulture, CrisisLeadershipFramework, BrandTrustCovenant, GlobalInnovationTreaty, and InnovationSupremeCourt.

contract PublicMattersIntegration {
    address public guardian;
    uint256 public covenantCount;
    uint256 public integrationCount;
    uint256 public councilCount;

    enum CovenantType {
        InnovationConstitution,
        InnovationFreedomCharter,
        InnovationMeritShield,
        BureaucraticAccountability,
        TransparencyCulture,
        CrisisLeadershipFramework,
        BrandTrustCovenant,
        GlobalInnovationTreaty,
        InnovationSupremeCourt
    }

    enum IntegrationStatus {
        Proposed,
        UnderReview,
        MultiCouncilReview,
        Integrated,
        Rejected
    }

    struct Covenant {
        uint256 id;
        CovenantType covenantType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Integration {
        uint256 id;
        CovenantType covenantType;
        string details;
        IntegrationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Covenant) public covenants;
    mapping(uint256 => Integration) public integrations;
    mapping(address => bool) public councilMember;

    event CovenantDeclared(uint256 indexed id, CovenantType covenantType);
    event CovenantLocked(uint256 indexed id);
    event IntegrationFiled(uint256 indexed id, CovenantType covenantType);
    event IntegrationStatusChanged(uint256 indexed id, IntegrationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        covenantCount = 0;
        integrationCount = 0;
        councilCount = 0;

        _declareDefaultCovenants();
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

    function _declareDefaultCovenants() internal {
        _declare(CovenantType.InnovationConstitution, "Unified constitutional covenant for innovation.");
        _declare(CovenantType.InnovationFreedomCharter, "Declares innovation as a constitutional right.");
        _declare(CovenantType.InnovationMeritShield, "Protects innovators whose work demonstrates merit.");
        _declare(CovenantType.BureaucraticAccountability, "Holds bureaucrats accountable for abuse.");
        _declare(CovenantType.TransparencyCulture, "Establishes radical transparency.");
        _declare(CovenantType.CrisisLeadershipFramework, "Ensures calm crisis leadership.");
        _declare(CovenantType.BrandTrustCovenant, "Declares brand trust as constitutional.");
        _declare(CovenantType.GlobalInnovationTreaty, "Extends protections internationally.");
        _declare(CovenantType.InnovationSupremeCourt, "Provides judicial oversight.");
    }

    function _declare(CovenantType covenantType, string memory description) internal {
        covenantCount++;
        covenants[covenantCount] = Covenant(
            covenantCount,
            covenantType,
            description,
            false,
            block.timestamp
        );
        emit CovenantDeclared(covenantCount, covenantType);
    }

    function lockCovenant(uint256 id) external onlyGuardian {
        Covenant storage c = covenants[id];
        require(!c.immutableEntry, "Already immutable");
        c.immutableEntry = true;
        emit CovenantLocked(id);
    }

    function fileIntegration(
        CovenantType covenantType,
        string calldata details
    ) external {
        integrationCount++;
        integrations[integrationCount] = Integration(
            integrationCount,
            covenantType,
            details,
            IntegrationStatus.Proposed,
            0,
            block.timestamp
        );

        emit IntegrationFiled(integrationCount, covenantType);
    }

    function beginReview(uint256 integrationId) external onlyCouncil {
        Integration storage i = integrations[integrationId];
        require(i.status == IntegrationStatus.Proposed, "Not proposed");
        i.status = IntegrationStatus.UnderReview;
        emit IntegrationStatusChanged(integrationId, IntegrationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 integrationId) external onlyCouncil {
        Integration storage i = integrations[integrationId];
        require(i.status == IntegrationStatus.UnderReview, "Not under review");
        i.status = IntegrationStatus.MultiCouncilReview;
        emit IntegrationStatusChanged(integrationId, IntegrationStatus.MultiCouncilReview);
    }

    function approveIntegration(uint256 integrationId) external onlyCouncil {
        Integration storage i = integrations[integrationId];
        require(i.status == IntegrationStatus.MultiCouncilReview, "Not in council stage");

        i.approvals++;

        if (i.approvals * 2 > councilCount && councilCount > 0) {
            i.status = IntegrationStatus.Integrated;
            emit IntegrationStatusChanged(integrationId, IntegrationStatus.Integrated);
        }
    }

    function rejectIntegration(uint256 integrationId) external onlyCouncil {
        Integration storage i = integrations[integrationId];
        require(
            i.status == IntegrationStatus.Proposed ||
            i.status == IntegrationStatus.UnderReview ||
            i.status == IntegrationStatus.MultiCouncilReview,
            "Invalid status"
        );
        i.status = IntegrationStatus.Rejected;
        emit IntegrationStatusChanged(integrationId, IntegrationStatus.Rejected);
    }
}
