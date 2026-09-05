// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PoliticalEndstate {
    struct Proposal {
        string description;
        string endstate;
        address proposer;
    }

    Proposal[] public proposals;

    event ProposalFiled(address proposer, string description, string endstate);

    function fileProposal(string calldata description, string calldata endstate) external {
        require(bytes(endstate).length > 0, "Endstate required");
        proposals.push(Proposal(description, endstate, msg.sender));
        emit ProposalFiled(msg.sender, description, endstate);
    }
}
