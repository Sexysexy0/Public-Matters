// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Vision Council
/// @notice Creator-only council that governs project direction and blocks managerial override
contract VisionCouncil {
    address public guardian;
    uint256 public councilCount;
    uint256 public proposalCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Subcontractor
    }

    enum ProposalStatus {
        Pending,
        Approved,
        Rejected
    }

    struct Member {
        uint256 id;
        address account;
        RoleType role;
        bool active;
    }

    struct Proposal {
        uint256 id;
        string title;
        string description;
        address proposer;
        ProposalStatus status;
        uint256 approvals;
        uint256 rejections;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        string subject;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Member) public members;
    mapping(address => uint256) public memberByAddress;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event MemberAdded(uint256 indexed id, address account, RoleType role);
    event ProposalSubmitted(uint256 indexed id, string title, address proposer);
    event ProposalApproved(uint256 indexed id, address approver);
    event ProposalRejected(uint256 indexed id, address rejector);
    event ViolationLogged(uint256 indexed id, address violator, string subject);

    constructor() {
        guardian = msg.sender;
        councilCount = 0;
        proposalCount = 0;
        violationCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        uint256 id = memberByAddress[msg.sender];
        require(id != 0, "Not registered");
        require(members[id].role == RoleType.Creator, "Creator only");
        _;
    }

    // Add council member
    function addMember(address account, RoleType role) external onlyGuardian {
        require(account != address(0), "Invalid account");
        require(memberByAddress[account] == 0, "Already exists");

        councilCount++;
        members[councilCount] = Member(councilCount, account, role, true);
        memberByAddress[account] = councilCount;

        emit MemberAdded(councilCount, account, role);
    }

    // Submit proposal (creator-only)
    function submitProposal(string calldata title, string calldata description)
        external
        onlyCreator
    {
        proposalCount++;
        proposals[proposalCount] = Proposal(
            proposalCount,
            title,
            description,
            msg.sender,
            ProposalStatus.Pending,
            0,
            0,
            block.timestamp
        );

        emit ProposalSubmitted(proposalCount, title, msg.sender);
    }

    // Approve proposal (creator-only)
    function approveProposal(uint256 id) external onlyCreator {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.Pending, "Not pending");

        p.approvals++;

        emit ProposalApproved(id, msg.sender);

        if (p.approvals >= 3) {
            p.status = ProposalStatus.Approved;
        }
    }

    // Reject proposal (creator-only)
    function rejectProposal(uint256 id) external onlyCreator {
        Proposal storage p = proposals[id];
        require(p.status == ProposalStatus.Pending, "Not pending");

        p.rejections++;

        emit ProposalRejected(id, msg.sender);

        if (p.rejections >= 3) {
            p.status = ProposalStatus.Rejected;
        }
    }

    // Manager or subcontractor override attempt = violation
    function attemptOverride(uint256 proposalId, string calldata reason) external {
        uint256 id = memberByAddress[msg.sender];
        RoleType role = id == 0 ? RoleType.Subcontractor : members[id].role;

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, proposals[proposalId].title, reason);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        string memory subject,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            subject,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, subject);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
