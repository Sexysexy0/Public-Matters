// RegressionDAO.sol
pragma solidity ^0.8.0;

contract RegressionDAO {
    struct Regression {
        uint256 id;
        string system;   // e.g. "Windows Terminal"
        string version;  // e.g. "1.23.13503.0"
        string issue;    // e.g. "Focus not applied"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public regressionCount;
    mapping(uint256 => Regression) public regressions;

    event RegressionCreated(uint256 id, string system, string version, string issue);
    event RegressionVoted(uint256 id, string system, bool support);
    event RegressionResolved(uint256 id, string system);
    event RegressionDeclared(string message);

    function createRegression(string memory system, string memory version, string memory issue) public {
        regressionCount++;
        regressions[regressionCount] = Regression(regressionCount, system, version, issue, 0, 0, false);
        emit RegressionCreated(regressionCount, system, version, issue);
    }

    function voteRegression(uint256 id, bool support) public {
        if (support) {
            regressions[id].votesFor++;
        } else {
            regressions[id].votesAgainst++;
        }
        emit RegressionVoted(id, regressions[id].system, support);
    }

    function resolveRegression(uint256 id) public {
        Regression storage r = regressions[id];
        require(!r.resolved, "Already resolved");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.resolved = true;
        emit RegressionResolved(r.id, r.system);
    }

    function declareRegression() public {
        emit RegressionDeclared("Regression DAO: safeguard arcs encoded into communal consequence.");
    }
}
