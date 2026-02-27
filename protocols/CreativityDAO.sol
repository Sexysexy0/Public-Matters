// CreativityDAO.sol
pragma solidity ^0.8.0;

contract CreativityDAO {
    struct Idea {
        uint256 id;
        string title;     // e.g. "Custom Kernel"
        string creator;   // e.g. "Community Dev"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public ideaCount;
    mapping(uint256 => Idea) public ideas;

    event IdeaCreated(uint256 id, string title, string creator);
    event IdeaVoted(uint256 id, string title, bool support);
    event IdeaRatified(uint256 id, string title);
    event CreativityDeclared(string message);

    function createIdea(string memory title, string memory creator) public {
        ideaCount++;
        ideas[ideaCount] = Idea(ideaCount, title, creator, 0, 0, false);
        emit IdeaCreated(ideaCount, title, creator);
    }

    function voteIdea(uint256 id, bool support) public {
        if (support) {
            ideas[id].votesFor++;
        } else {
            ideas[id].votesAgainst++;
        }
        emit IdeaVoted(id, ideas[id].title, support);
    }

    function ratifyIdea(uint256 id) public {
        Idea storage i = ideas[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit IdeaRatified(i.id, i.title);
    }

    function declareCreativity() public {
        emit CreativityDeclared("Creativity DAO: safeguard arcs encoded into communal consequence.");
    }
}
