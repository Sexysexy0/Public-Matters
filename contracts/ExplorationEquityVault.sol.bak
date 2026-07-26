// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ExplorationEquityVault {
    struct Quest {
        address explorer;
        string region;
        string reward;
        uint256 timestamp;
        bool completed;
    }

    Quest[] public quests;

    event QuestLogged(address indexed explorer, string region, string reward);
    event QuestCompleted(uint256 indexed id, address verifier);

    function logQuest(string memory _region, string memory _reward) public {
        quests.push(Quest(msg.sender, _region, _reward, block.timestamp, false));
        emit QuestLogged(msg.sender, _region, _reward);
    }

    function completeQuest(uint256 _id) public {
        require(_id < quests.length, "Invalid ID");
        quests[_id].completed = true;
        emit QuestCompleted(_id, msg.sender);
    }

    function getQuest(uint256 _id) public view returns (Quest memory) {
        require(_id < quests.length, "Invalid ID");
        return quests[_id];
    }

    function totalQuests() public view returns (uint256) {
        return quests.length;
    }
}
