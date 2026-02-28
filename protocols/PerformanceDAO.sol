// PerformanceDAO.sol
pragma solidity ^0.8.0;

contract PerformanceDAO {
    struct Show {
        uint256 id;
        string artist;    // e.g. "Post Malone"
        string detail;    // e.g. "AI ghostwriter song performed live"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public showCount;
    mapping(uint256 => Show) public shows;

    event ShowCreated(uint256 id, string artist, string detail);
    event ShowVoted(uint256 id, string artist, bool support);
    event ShowRatified(uint256 id, string artist);
    event PerformanceDeclared(string message);

    function createShow(string memory artist, string memory detail) public {
        showCount++;
        shows[showCount] = Show(showCount, artist, detail, 0, 0, false);
        emit ShowCreated(showCount, artist, detail);
    }

    function voteShow(uint256 id, bool support) public {
        if (support) {
            shows[id].votesFor++;
        } else {
            shows[id].votesAgainst++;
        }
        emit ShowVoted(id, shows[id].artist, support);
    }

    function ratifyShow(uint256 id) public {
        Show storage s = shows[id];
        require(!s.ratified, "Already ratified");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.ratified = true;
        emit ShowRatified(s.id, s.artist);
    }

    function declarePerformance() public {
        emit PerformanceDeclared("Performance DAO: safeguard arcs encoded into communal consequence.");
    }
}
