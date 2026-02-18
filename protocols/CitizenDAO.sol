// CitizenDAO.sol
pragma solidity ^0.8.0;

contract CitizenDAO {
    struct Motion {
        uint256 id;
        string issue;    // e.g. "Utility Transparency"
        string proposer; // e.g. "Community Group"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public motionCount;
    mapping(uint256 => Motion) public motions;

    event MotionCreated(uint256 id, string issue, string proposer);
    event MotionVoted(uint256 id, string issue, bool support);
    event MotionRatified(uint256 id, string issue);
    event CitizenDeclared(string message);

    function createMotion(string memory issue, string memory proposer) public {
        motionCount++;
        motions[motionCount] = Motion(motionCount, issue, proposer, 0, 0, false);
        emit MotionCreated(motionCount, issue, proposer);
    }

    function voteMotion(uint256 id, bool support) public {
        if (support) {
            motions[id].votesFor++;
        } else {
            motions[id].votesAgainst++;
        }
        emit MotionVoted(id, motions[id].issue, support);
    }

    function ratifyMotion(uint256 id) public {
        Motion storage m = motions[id];
        require(!m.ratified, "Already ratified");
        require(m.votesFor > m.votesAgainst, "Not enough support");
        m.ratified = true;
        emit MotionRatified(m.id, m.issue);
    }

    function declareCitizen() public {
        emit CitizenDeclared("Citizen DAO: safeguard arcs encoded into communal consequence.");
    }
}
