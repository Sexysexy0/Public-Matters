// AntiDarkPatternDAO.sol
pragma solidity ^0.8.0;

contract AntiDarkPatternDAO {
    struct Pattern {
        uint256 id;
        string tactic;   // e.g. "Hidden Cancel Button", "Forced Renewal"
        string status;   // e.g. "Detected", "Removed"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public patternCount;
    mapping(uint256 => Pattern) public patterns;

    event PatternCreated(uint256 id, string tactic, string status);
    event PatternVoted(uint256 id, string tactic, bool support);
    event PatternResolved(uint256 id, string tactic);
    event DarkPatternDeclared(string message);

    function createPattern(string memory tactic, string memory status) public {
        patternCount++;
        patterns[patternCount] = Pattern(patternCount, tactic, status, 0, 0, false);
        emit PatternCreated(patternCount, tactic, status);
    }

    function votePattern(uint256 id, bool support) public {
        if (support) {
            patterns[id].votesFor++;
        } else {
            patterns[id].votesAgainst++;
        }
        emit PatternVoted(id, patterns[id].tactic, support);
    }

    function resolvePattern(uint256 id) public {
        Pattern storage p = patterns[id];
        require(!p.resolved, "Already resolved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.resolved = true;
        emit PatternResolved(p.id, p.tactic);
    }

    function declareDarkPattern() public {
        emit DarkPatternDeclared("Anti-Dark Pattern DAO: safeguard arcs encoded into communal consequence.");
    }
}
