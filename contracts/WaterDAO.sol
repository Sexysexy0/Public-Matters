// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WaterDAO
/// @notice Governance contract to manage voting + execution flow for water authority and communal rights
/// @dev Integrates WaterGovernanceReversion + CommunalWaterRights

interface IWaterGovernanceReversion {
    function revertAuthority() external;
    function isReverted() external view returns (bool);
}

interface ICommunalWaterRights {
    function registerResident(address resident) external;
    function revokeAccess(address resident, string calldata reason) external;
    function restoreAccess(address resident) external;
    function hasRights(address resident) external view returns (bool);
}

contract WaterDAO {
    address public chair;
    IWaterGovernanceReversion public governance;
    ICommunalWaterRights public rights;

    struct Proposal {
        uint256 id;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => bool) public voters;
    uint256 public proposalCount;

    event ProposalCreated(uint256 id, string description, uint256 timestamp);
    event Voted(uint256 id, address voter, bool support, uint256 timestamp);
    event Executed(uint256 id, string action, uint256 timestamp);

    modifier onlyChair() {
        require(msg.sender == chair, "Not authorized");
        _;
    }

    constructor(address _chair, address _governance, address _rights) {
        chair = _chair;
        governance = IWaterGovernanceReversion(_governance);
        rights = ICommunalWaterRights(_rights);
    }

    /// @notice Create a new governance proposal
    function createProposal(string calldata description) external onlyChair {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, description, 0, 0, false);
        emit ProposalCreated(proposalCount, description, block.timestamp);
    }

    /// @notice Cast a vote on a proposal
    function vote(uint256 id, bool support) external {
        require(!voters[msg.sender], "Already voted");
        require(!proposals[id].executed, "Already executed");
        voters[msg.sender] = true;

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support, block.timestamp);
    }

    /// @notice Execute a proposal if majority votes are in favor
    function executeProposal(uint256 id) external onlyChair {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not approved");

        // Example action: revert authority
        governance.revertAuthority();
        p.executed = true;
        emit Executed(id, "Authority reverted to Malolos Water District", block.timestamp);
    }
}
