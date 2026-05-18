// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReputationEquityArc {
    event ReputationEarned(address indexed member, uint256 points, string context);
    event ReputationSpent(address indexed member, uint256 points, string purpose);
    event ReputationTransferred(address indexed from, address indexed to, uint256 points);

    mapping(address => uint256) public reputation;

    function earnReputation(address member, uint256 points, string memory context) external {
        reputation[member] += points;
        emit ReputationEarned(member, points, context);
        // ARC: Reputation earned through contributions (mods, preservation, feedback, funding).
    }

    function spendReputation(address member, uint256 points, string memory purpose) external {
        require(reputation[member] >= points, "Not enough reputation");
        reputation[member] -= points;
        emit ReputationSpent(member, points, purpose);
        // ARC: Reputation spent for governance actions (votes, proposals, trust badges).
    }

    function transferReputation(address to, uint256 points) external {
        require(reputation[msg.sender] >= points, "Not enough reputation");
        reputation[msg.sender] -= points;
        reputation[to] += points;
        emit ReputationTransferred(msg.sender, to, points);
        // ARC: Allow peer‑to‑peer recognition, but reputation cannot be bought externally.
    }

    function getReputation(address member) external view returns (uint256) {
        return reputation[member];
    }
}
