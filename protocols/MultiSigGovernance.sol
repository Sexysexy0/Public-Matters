// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigGovernance {
    address[] public signers;
    uint public required;

    struct Proposal {
        string description;
        uint approvals;
        bool executed;
    }

    Proposal[] public proposals;
    mapping(uint => mapping(address => bool)) public approved;

    constructor(address[] memory _signers, uint _required) {
        signers = _signers;
        required = _required;
    }

    function createProposal(string memory description) public {
        proposals.push(Proposal(description, 0, false));
    }

    function approve(uint proposalId) public {
        require(isSigner(msg.sender), "Not signer");
        require(!approved[proposalId][msg.sender], "Already approved");
        approved[proposalId][msg.sender] = true;
        proposals[proposalId].approvals++;
    }

    function execute(uint proposalId) public view returns (string memory) {
        Proposal memory p = proposals[proposalId];
        if (p.approvals >= required) {
            return "Proposal PASSED";
        } else {
            return "Proposal PENDING";
        }
    }

    function isSigner(address addr) internal view returns (bool) {
        for (uint i = 0; i < signers.length; i++) {
            if (signers[i] == addr) return true;
        }
        return false;
    }
}
