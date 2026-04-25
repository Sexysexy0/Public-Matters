// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract QuestOracle {
    event QuestCompleted(address squad, string objective);

    function completeQuest(address _squad, string memory _objective) external {
        emit QuestCompleted(_squad, _objective);
        // ORACLE: Quest progression logged on-chain.
    }
}
