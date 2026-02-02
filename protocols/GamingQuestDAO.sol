// GamingQuestDAO.sol
pragma solidity ^0.8.0;

contract GamingQuestDAO {
    struct Quest {
        uint256 id;
        string name;
        string description;
        uint256 reward;
        bool completed;
    }

    uint256 public questCount;
    mapping(uint256 => Quest) public quests;
    mapping(address => mapping(uint256 => bool)) public hasJoined;

    event QuestCreated(uint256 id, string name, string description, uint256 reward);
    event QuestJoined(address indexed player, uint256 questId);
    event QuestCompleted(uint256 id, string name);
    event QuestDeclared(string message);

    function createQuest(string memory name, string memory description, uint256 reward) public {
        questCount++;
        quests[questCount] = Quest(questCount, name, description, reward, false);
        emit QuestCreated(questCount, name, description, reward);
    }

    function joinQuest(uint256 questId) public {
        require(!hasJoined[msg.sender][questId], "Already joined");
        hasJoined[msg.sender][questId] = true;
        emit QuestJoined(msg.sender, questId);
    }

    function completeQuest(uint256 questId) public {
        Quest storage q = quests[questId];
        require(!q.completed, "Already completed");
        q.completed = true;
        emit QuestCompleted(q.id, q.name);
    }

    function declareQuest() public {
        emit QuestDeclared("Gaming Quest DAO: collective play-to-earn quests igniting crypto adoption.");
    }
}
