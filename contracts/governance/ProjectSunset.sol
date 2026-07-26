// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./InstitutionalAuditHistory.sol";
import "./GovernanceSimulation.sol";

contract ProjectSunset {
    struct Proposal {
        string projectName;
        uint256 votesFor;
        uint256 votesAgainst;
        bool executed;
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    InstitutionalAuditHistory public immutable auditLog;
    GovernanceSimulation public immutable governanceSim;

    event ProposalCreated(uint256 indexed id, string projectName);
    event Voted(uint256 indexed id, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed id, string projectName);

    constructor(address _auditLog, address _governanceSim) {
        auditLog = InstitutionalAuditHistory(_auditLog);
        governanceSim = GovernanceSimulation(_governanceSim);
    }

    function createProposal(string memory projectName) external {
        proposalCount++;
        proposals[proposalCount] = Proposal(projectName, 0, 0, false);

        emit ProposalCreated(proposalCount, projectName);

        if (address(auditLog) != address(0)) {
            auditLog.logEvent(msg.sender, "CREATE_PROPOSAL", abi.encode(projectName));
        }
        if (address(governanceSim) != address(0)) {
            governanceSim.simulate("CREATE_PROPOSAL", abi.encode(projectName));
        }
    }

    function vote(uint256 id, bool support) external {
        require(id <= proposalCount, "Invalid proposal");
        require(!proposals[id].executed, "Already executed");

        if (support) {
            proposals[id].votesFor++;
        } else {
            proposals[id].votesAgainst++;
        }

        emit Voted(id, msg.sender, support);

        if (address(auditLog) != address(0)) {
            auditLog.logEvent(msg.sender, "VOTE", abi.encode(id, support));
        }
        if (address(governanceSim) != address(0)) {
            governanceSim.simulate("VOTE", abi.encode(id, msg.sender, support));
        }
    }

    function executeProposal(uint256 id) external {
        Proposal storage p = proposals[id];
        require(!p.executed, "Already executed");
        require(p.votesFor > p.votesAgainst, "Not approved");

        p.executed = true;
        emit ProposalExecuted(id, p.projectName);

        if (address(auditLog) != address(0)) {
            auditLog.logEvent(msg.sender, "EXECUTE_PROPOSAL", abi.encode(id, p.projectName));
        }
        if (address(governanceSim) != address(0)) {
            governanceSim.simulate("EXECUTE_PROPOSAL", abi.encode(id, p.projectName));
        }
    }
}
