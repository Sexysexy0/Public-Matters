// FundingDAO.sol
pragma solidity ^0.8.0;

contract FundingDAO {
    struct Grant {
        uint256 id;
        string source;    // e.g. "Private Business"
        string purpose;   // e.g. "Government Payroll"
        uint256 amount;
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public grantCount;
    mapping(uint256 => Grant) public grants;

    event GrantCreated(uint256 id, string source, string purpose, uint256 amount);
    event GrantVoted(uint256 id, string source, bool support);
    event GrantRatified(uint256 id, string source);
    event FundingDeclared(string message);

    function createGrant(string memory source, string memory purpose, uint256 amount) public {
        grantCount++;
        grants[grantCount] = Grant(grantCount, source, purpose, amount, 0, 0, false);
        emit GrantCreated(grantCount, source, purpose, amount);
    }

    function voteGrant(uint256 id, bool support) public {
        if (support) {
            grants[id].votesFor++;
        } else {
            grants[id].votesAgainst++;
        }
        emit GrantVoted(id, grants[id].source, support);
    }

    function ratifyGrant(uint256 id) public {
        Grant storage g = grants[id];
        require(!g.ratified, "Already ratified");
        require(g.votesFor > g.votesAgainst, "Not enough support");
        g.ratified = true;
        emit GrantRatified(g.id, g.source);
    }

    function declareFunding() public {
        emit FundingDeclared("Funding DAO: safeguard arcs encoded into communal consequence.");
    }
}
