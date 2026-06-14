// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityOversightBridge
/// @notice Bridge covenant to formalize player voting and veto power
contract CommunityOversightBridge {
    address public overseer;
    uint256 public proposalCount;

    struct Proposal {
        uint256 id;
        string covenant;    // reference to covenant (e.g. Monetization, UI, Innovation)
        string description; // what is being proposed
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 timestamp;
        bool ratified;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint256 indexed id, string covenant, string description);
    event Voted(uint256 indexed id, address voter, bool support);
    event Ratified(uint256 indexed id, bool ratified);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer creates a new proposal
    function createProposal(string calldata covenant, string calldata description) external onlyOverseer {
        proposalCount++;
        proposals[proposalCount] = Proposal({
            id: proposalCount,
            covenant: covenant,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            timestamp: block.timestamp,
            ratified: false
        });
        emit ProposalCreated(proposalCount, covenant, description);
    }

    /// @notice Citizens vote on proposal
    function vote(uint256 id, bool support) external {
        require(!hasVoted[id][msg.sender], "Already voted");
        hasVoted[id][msg.sender] = true;
        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }
        emit Voted(id, msg.sender, support);
    }

    /// @notice Overseer ratifies proposal if majority supports
    function ratify(uint256 id) external onlyOverseer {
        Proposal storage p = proposals[id];
        require(!p.ratified, "Already ratified");
        if (p.votesFor > p.votesAgainst) {
            p.ratified = true;
        }
        emit Ratified(id, p.ratified);
    }
}
