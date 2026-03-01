// InflationDAO.sol
pragma solidity ^0.8.0;

contract InflationDAO {
    struct Index {
        uint256 id;
        string domain;    // e.g. "Consumer Prices"
        string detail;    // e.g. "Annual inflation rate"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public indexCount;
    mapping(uint256 => Index) public indices;

    event IndexCreated(uint256 id, string domain, string detail);
    event IndexVoted(uint256 id, string domain, bool support);
    event IndexRatified(uint256 id, string domain);
    event InflationDeclared(string message);

    function createIndex(string memory domain, string memory detail) public {
        indexCount++;
        indices[indexCount] = Index(indexCount, domain, detail, 0, 0, false);
        emit IndexCreated(indexCount, domain, detail);
    }

    function voteIndex(uint256 id, bool support) public {
        if (support) {
            indices[id].votesFor++;
        } else {
            indices[id].votesAgainst++;
        }
        emit IndexVoted(id, indices[id].domain, support);
    }

    function ratifyIndex(uint256 id) public {
        Index storage i = indices[id];
        require(!i.ratified, "Already ratified");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.ratified = true;
        emit IndexRatified(i.id, i.domain);
    }

    function declareInflation() public {
        emit InflationDeclared("Inflation DAO: safeguard arcs encoded into communal consequence.");
    }
}
