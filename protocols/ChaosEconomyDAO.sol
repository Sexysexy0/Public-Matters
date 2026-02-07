// ChaosEconomyDAO.sol
pragma solidity ^0.8.0;

contract ChaosEconomyDAO {
    struct Activity {
        uint256 id;
        string type;   // e.g. "Riot", "Protest"
        string funding; // e.g. "Paid", "Volunteer"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public activityCount;
    mapping(uint256 => Activity) public activities;

    event ActivityCreated(uint256 id, string type, string funding);
    event ActivityVoted(uint256 id, string type, bool support);
    event ActivityPublished(uint256 id, string type);
    event ChaosDeclared(string message);

    function createActivity(string memory type, string memory funding) public {
        activityCount++;
        activities[activityCount] = Activity(activityCount, type, funding, 0, 0, false);
        emit ActivityCreated(activityCount, type, funding);
    }

    function voteActivity(uint256 id, bool support) public {
        if (support) {
            activities[id].votesFor++;
        } else {
            activities[id].votesAgainst++;
        }
        emit ActivityVoted(id, activities[id].type, support);
    }

    function publishActivity(uint256 id) public {
        Activity storage a = activities[id];
        require(!a.published, "Already published");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.published = true;
        emit ActivityPublished(a.id, a.type);
    }

    function declareChaos() public {
        emit ChaosDeclared("Chaos Economy DAO: safeguard arcs encoded into communal consequence.");
    }
}
