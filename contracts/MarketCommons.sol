// contracts/MarketCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MarketCommons
 * @notice Ledger for modernization proposals, vendor protests, and communal verdicts in public markets.
 */
contract MarketCommons {
    address public admin;

    struct Proposal {
        string proposer;
        string description;
        string status;   // "Pending", "Approved", "Rejected"
        uint256 timestamp;
    }

    Proposal[] public proposals;

    event ProposalLogged(string proposer, string description, string status, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() { admin = msg.sender; }

    function logProposal(string calldata proposer, string calldata description, string calldata status) external onlyAdmin {
        proposals.push(Proposal(proposer, description, status, block.timestamp));
        emit ProposalLogged(proposer, description, status, block.timestamp);
    }

    function totalProposals() external view returns (uint256) { return proposals.length; }

    function getProposal(uint256 id) external view returns (Proposal memory) {
        require(id < proposals.length, "Invalid id");
        return proposals[id];
    }
}
