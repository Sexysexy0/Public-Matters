// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Council
/// @notice Collective governance layer for covenant decisions
contract CovenantCouncil {
    address public guardian;
    mapping(address => bool) public councilMembers;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CouncilMemberSet(address indexed member, bool status);
    event ProposalCreated(uint256 indexed id, string description);
    event Voted(uint256 indexed id, address indexed member, bool support);
    event ProposalExecuted(uint256 indexed id, bool passed);

    constructor() {
        guardian = msg.sender;
        proposalCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCouncil() {
        require(councilMembers[msg.sender], "Not a council member");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑set ng council member
    function setCouncilMember(address member, bool status) external onlyGuardian {
        councilMembers[member] = status;
        emit CouncilMemberSet(member, status);
    }

    /// @notice Gumawa ng proposal
    function createProposal(string calldata description) external onlyCouncil {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0, false);
        emit ProposalCreated(proposalCount, description);
    }

    /// @notice Bumoto sa proposal
    function vote(uint256 id, bool support) external onlyCouncil {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");

        if (support) {
            p.votesFor++;
        } else {
            p.votesAgainst++;
        }

        emit Voted(id, msg.sender, support);
    }

    /// @notice I‑execute ang proposal kung pasado
    function executeProposal(uint256 id) external onlyCouncil {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");

        p.executed = true;
        bool passed = p.votesFor > p.votesAgainst;

        emit ProposalExecuted(id, passed);
    }
}
