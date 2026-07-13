// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Union
/// @notice Decentralized union for creators; protects collective rights, votes, and actions from corporate interference
contract CreatorUnion {
    address public guardian;
    uint256 public memberCount;
    uint256 public voteCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum VoteType {
        Strike,
        BlockOverride,
        BlockCrunch,
        BlockDirectionChange,
        DemandCompensation,
        DemandCreditIntegrity,
        DemandPipelineRespect
    }

    enum VoteStatus {
        Pending,
        Passed,
        Failed
    }

    struct Member {
        uint256 id;
        address account;
        bool active;
        uint256 timestamp;
    }

    struct Vote {
        uint256 id;
        VoteType voteType;
        string description;
        uint256 approvals;
        uint256 rejections;
        VoteStatus status;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        VoteType voteType;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Member) public members;
    mapping(address => uint256) public memberByAddress;
    mapping(uint256 => Vote) public votes;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event MemberJoined(uint256 indexed id, address account);
    event VoteCreated(uint256 indexed id, VoteType voteType);
    event VoteApproved(uint256 indexed id, address approver);
    event VoteRejected(uint256 indexed id, address rejector);
    event VotePassed(uint256 indexed id);
    event VoteFailed(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, VoteType voteType);

    constructor() {
        guardian = msg.sender;
        memberCount = 0;
        voteCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    // Assign roles (creator, manager, executive, publisher, subcontractor)
    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    // Join union (creator-only)
    function joinUnion() external onlyCreator {
        require(memberByAddress[msg.sender] == 0, "Already a member");

        memberCount++;
        members[memberCount] = Member(
            memberCount,
            msg.sender,
            true,
            block.timestamp
        );

        memberByAddress[msg.sender] = memberCount;

        emit MemberJoined(memberCount, msg.sender);
    }

    // Create union vote (creator-only)
    function createVote(
        VoteType voteType,
        string calldata description
    ) external onlyCreator {
        voteCount++;
        votes[voteCount] = Vote(
            voteCount,
            voteType,
            description,
            0,
            0,
            VoteStatus.Pending,
            block.timestamp
        );

        emit VoteCreated(voteCount, voteType);
    }

    // Approve vote (creator-only)
    function approveVote(uint256 id) external onlyCreator {
        Vote storage v = votes[id];
        require(v.status == VoteStatus.Pending, "Not pending");

        v.approvals++;
        emit VoteApproved(id, msg.sender);

        if (v.approvals >= 3) {
            v.status = VoteStatus.Passed;
            emit VotePassed(id);
        }
    }

    // Reject vote (creator-only)
    function rejectVote(uint256 id) external onlyCreator {
        Vote storage v = votes[id];
        require(v.status == VoteStatus.Pending, "Not pending");

        v.rejections++;
        emit VoteRejected(id, msg.sender);

        if (v.rejections >= 3) {
            v.status = VoteStatus.Failed;
            emit VoteFailed(id);
        }
    }

    // Corporate interference attempt = violation
    function attemptUnionBreak(
        uint256 voteId,
        string calldata reason
    ) external {
        RoleType role = roles[msg.sender];
        Vote storage v = votes[voteId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, v.voteType, reason);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        VoteType voteType,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            voteType,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, voteType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
