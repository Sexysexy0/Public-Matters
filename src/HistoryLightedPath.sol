// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HistoryLightedPath {
    struct Decision {
        address leader;
        string description;
        uint256 blockNumber;
    }

    Decision[] public decisions;

    event DecisionLogged(address leader, string description, uint256 blockNumber);

    function logDecision(string calldata description) external {
        decisions.push(Decision(msg.sender, description, block.number));
        emit DecisionLogged(msg.sender, description, block.number);
    }
}
