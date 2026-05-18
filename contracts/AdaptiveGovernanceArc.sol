// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AdaptiveGovernanceArc {
    event VoteCast(address indexed voter, uint256 weight, string proposal);
    event ReputationEarned(address indexed member, uint256 points, string context);

    mapping(address => uint256) public contributions;
    mapping(address => uint256) public reputation;
    mapping(address => uint256) public lastActive;

    function recordContribution(address member, uint256 amount) external {
        contributions[member] += amount;
        reputation[member] += amount / 10; // reputation bonus
        lastActive[member] = block.timestamp;
        emit ReputationEarned(member, amount / 10, "Contribution logged");
    }

    function calculateWeight(address member) public view returns (uint256) {
        uint256 base = contributions[member];
        uint256 rep = reputation[member];
        uint256 decay = (block.timestamp - lastActive[member]) / 30 days;
        if (decay > base) { base = 0; } else { base -= decay; }
        return base + rep;
    }

    function castVote(string memory proposal) external {
        uint256 weight = calculateWeight(msg.sender);
        require(weight > 0, "No voting power");
        emit VoteCast(msg.sender, weight, proposal);
    }
}
