// AICompetitionDAO.sol
pragma solidity ^0.8.0;

contract AICompetitionDAO {
    struct Rivalry {
        uint256 id;
        string actor;   // e.g. "DeepSeek"
        string target;  // e.g. "OpenAI"
        string method;  // e.g. "Replication", "Distillation"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public rivalryCount;
    mapping(uint256 => Rivalry) public rivalries;

    event RivalryCreated(uint256 id, string actor, string target, string method);
    event RivalryVoted(uint256 id, string actor, bool support);
    event RivalryResolved(uint256 id, string actor);
    event CompetitionDeclared(string message);

    function createRivalry(string memory actor, string memory target, string memory method) public {
        rivalryCount++;
        rivalries[rivalryCount] = Rivalry(rivalryCount, actor, target, method, 0, 0, false);
        emit RivalryCreated(rivalryCount, actor, target, method);
    }

    function voteRivalry(uint256 id, bool support) public {
        if (support) {
            rivalries[id].votesFor++;
        } else {
            rivalries[id].votesAgainst++;
        }
        emit RivalryVoted(id, rivalries[id].actor, support);
    }

    function resolveRivalry(uint256 id) public {
        Rivalry storage r = rivalries[id];
        require(!r.resolved, "Already resolved");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.resolved = true;
        emit RivalryResolved(r.id, r.actor);
    }

    function declareCompetition() public {
        emit CompetitionDeclared("AI Competition DAO: safeguard arcs encoded into communal consequence.");
    }
}
