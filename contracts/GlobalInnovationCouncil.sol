// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Global Innovation Council
/// @notice Establishes a global council oversight body for innovation governance.
/// @dev Integrates with PublicMattersIntegration, GlobalInnovationTreaty, and InnovationSupremeCourt.

contract GlobalInnovationCouncil {
    address public guardian;
    uint256 public councilCount;
    uint256 public motionCount;
    uint256 public resolutionCount;

    enum RoleType {
        Nation,
        Innovator,
        Founder,
        PublicServant,
        CouncilMember,
        Oversight,
        TreatyMember
    }

    enum MotionType {
        CovenantIntegration,
        TreatyRatification,
        CrisisOversight,
        TransparencyEnforcement,
        BrandTrustProtection,
        SupremeCourtAppeal,
        GlobalInnovationProtection
    }

    enum ResolutionStatus {
        Proposed,
        UnderReview,
        MultiCouncilReview,
        Approved,
        Rejected,
        Enforced
    }

    struct Motion {
        uint256 id;
        MotionType motionType;
        string description;
        ResolutionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Motion) public motions;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMembers;

    event MotionFiled(uint256 indexed id, MotionType motionType);
    event ResolutionStatusChanged(uint256 indexed id, ResolutionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        councilCount = 0;
        motionCount = 0;
        resolutionCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMembers[msg.sender], "Council only");
        _;
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
    }

    function addCouncilMember(address member) external onlyGuardian {
        require(!councilMembers[member], "Already council");
        councilMembers[member] = true;
        councilCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(councilMembers[member], "Not council");
        councilMembers[member] = false;
        councilCount--;
        emit CouncilMemberRemoved(member);
    }

    function fileMotion(MotionType motionType, string calldata description) external onlyCouncil {
        motionCount++;
        motions[motionCount] = Motion(
            motionCount,
            motionType,
            description,
            ResolutionStatus.Proposed,
            0,
            block.timestamp
        );

        emit MotionFiled(motionCount, motionType);
    }

    function beginReview(uint256 motionId) external onlyCouncil {
        Motion storage m = motions[motionId];
        require(m.status == ResolutionStatus.Proposed, "Not proposed");
        m.status = ResolutionStatus.UnderReview;
        emit ResolutionStatusChanged(motionId, ResolutionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 motionId) external onlyCouncil {
        Motion storage m = motions[motionId];
        require(m.status == ResolutionStatus.UnderReview, "Not under review");
        m.status = ResolutionStatus.MultiCouncilReview;
        emit ResolutionStatusChanged(motionId, ResolutionStatus.MultiCouncilReview);
    }

    function approveMotion(uint256 motionId) external onlyCouncil {
        Motion storage m = motions[motionId];
        require(m.status == ResolutionStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = ResolutionStatus.Approved;
            resolutionCount++;
            emit ResolutionStatusChanged(motionId, ResolutionStatus.Approved);
        }
    }

    function enforceResolution(uint256 motionId) external onlyCouncil {
        Motion storage m = motions[motionId];
        require(m.status == ResolutionStatus.Approved, "Not approved");
        m.status = ResolutionStatus.Enforced;
        emit ResolutionStatusChanged(motionId, ResolutionStatus.Enforced);
    }

    function rejectMotion(uint256 motionId) external onlyCouncil {
        Motion storage m = motions[motionId];
        require(
            m.status == ResolutionStatus.Proposed ||
            m.status == ResolutionStatus.UnderReview ||
            m.status == ResolutionStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = ResolutionStatus.Rejected;
        emit ResolutionStatusChanged(motionId, ResolutionStatus.Rejected);
    }
}
