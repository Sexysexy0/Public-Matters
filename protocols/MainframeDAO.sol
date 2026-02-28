// MainframeDAO.sol
pragma solidity ^0.8.0;

contract MainframeDAO {
    struct System {
        uint256 id;
        string sector;    // e.g. "Insurance"
        string detail;    // e.g. "COBOL mainframe for claims"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public systemCount;
    mapping(uint256 => System) public systems;

    event SystemCreated(uint256 id, string sector, string detail);
    event SystemVoted(uint256 id, string sector, bool support);
    event SystemRatified(uint256 id, string sector);
    event MainframeDeclared(string message);

    function createSystem(string memory sector, string memory detail) public {
        systemCount++;
        systems[systemCount] = System(systemCount, sector, detail, 0, 0, false);
        emit SystemCreated(systemCount, sector, detail);
    }

    function voteSystem(uint256 id, bool support) public {
        if (support) {
            systems[id].votesFor++;
        } else {
            systems[id].votesAgainst++;
        }
        emit SystemVoted(id, systems[id].sector, support);
    }

    function ratifySystem(uint256 id) public {
        System storage s = systems[id];
        require(!s.ratified, "Already ratified");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.ratified = true;
        emit SystemRatified(s.id, s.sector);
    }

    function declareMainframe() public {
        emit MainframeDeclared("Mainframe DAO: safeguard arcs encoded into communal consequence.");
    }
}
