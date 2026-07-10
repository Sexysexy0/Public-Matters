// SPDX-License-Identifier: MIT
// Contract Name: UnityConsensusProtocol
// Purpose: Collective decision-making safeguard to prevent imbalance
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract UnityConsensusProtocol {
    address public chiefOperator;
    uint256 public proposalCount;

    struct Proposal {
        string description;
        uint256 approvals;
        uint256 rejections;
        uint256 timestamp;
        bool executed;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint256 indexed id, string description, uint256 timestamp);
    event ProposalVoted(uint256 indexed id, address voter, bool approval);
    event ProposalExecuted(uint256 indexed id, string description);

    constructor() {
        chiefOperator = msg.sender;
        proposalCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Create new proposal for collective decision
    function createProposal(string memory description) public onlyChief {
        proposals.push(Proposal(description, 0, 0, block.timestamp, false));
        proposalCount++;
        emit ProposalCreated(proposalCount - 1, description, block.timestamp);
    }

    // Vote on proposal
    function vote(uint256 id, bool approve) public {
        require(id < proposals.length, "Invalid proposal ID");
        require(!proposals[id].executed, "Proposal already executed");

        if (approve) {
            proposals[id].approvals++;
        } else {
            proposals[id].rejections++;
        }
        emit ProposalVoted(id, msg.sender, approve);
    }

    // Execute proposal if majority approves
    function executeProposal(uint256 id) public onlyChief {
        require(id < proposals.length, "Invalid proposal ID");
        require(!proposals[id].executed, "Proposal already executed");
        require(proposals[id].approvals > proposals[id].rejections, "Not enough approvals");

        proposals[id].executed = true;
        emit ProposalExecuted(id, proposals[id].description);
    }
}
