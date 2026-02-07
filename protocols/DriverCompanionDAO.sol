// DriverCompanionDAO.sol
pragma solidity ^0.8.0;

contract DriverCompanionDAO {
    struct Companion {
        uint256 id;
        string feature;   // e.g. "Navigation", "Entertainment"
        string feedback;  // e.g. "Helpful", "Distracting"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public companionCount;
    mapping(uint256 => Companion) public companions;

    event CompanionCreated(uint256 id, string feature, string feedback);
    event CompanionVoted(uint256 id, string feature, bool support);
    event CompanionPublished(uint256 id, string feature);
    event CompanionDeclared(string message);

    function createCompanion(string memory feature, string memory feedback) public {
        companionCount++;
        companions[companionCount] = Companion(companionCount, feature, feedback, 0, 0, false);
        emit CompanionCreated(companionCount, feature, feedback);
    }

    function voteCompanion(uint256 id, bool support) public {
        if (support) {
            companions[id].votesFor++;
        } else {
            companions[id].votesAgainst++;
        }
        emit CompanionVoted(id, companions[id].feature, support);
    }

    function publishCompanion(uint256 id) public {
        Companion storage c = companions[id];
        require(!c.published, "Already published");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.published = true;
        emit CompanionPublished(c.id, c.feature);
    }

    function declareCompanion() public {
        emit CompanionDeclared("Driver Companion DAO: safeguard arcs encoded into communal consequence.");
    }
}
