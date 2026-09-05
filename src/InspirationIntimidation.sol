// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InspirationIntimidation {
    struct Proposal {
        string description;
        uint256 inspirationScore;
        uint256 intimidationScore;
        address proposer;
    }

    Proposal[] public proposals;

    event ProposalFiled(address proposer, string description, uint256 inspiration, uint256 intimidation);

    function fileProposal(
        string calldata description,
        uint256 inspiration,
        uint256 intimidation
    ) external {
        require(inspiration + intimidation > 0, "Scores required");
        proposals.push(Proposal(description, inspiration, intimidation, msg.sender));
        emit ProposalFiled(msg.sender, description, inspiration, intimidation);
    }

    function balanceCheck(uint256 id) external view returns (bool) {
        Proposal memory p = proposals[id];
        return p.inspirationScore >= p.intimidationScore;
    }
}
