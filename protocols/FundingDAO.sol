// FundingDAO.sol
pragma solidity ^0.8.0;

contract FundingDAO {
    struct Stream {
        uint256 id;
        string domain;    // e.g. "Hybrid Monetization"
        string detail;    // e.g. "Sponsors, consulting, SaaS"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public streamCount;
    mapping(uint256 => Stream) public streams;

    event StreamCreated(uint256 id, string domain, string detail);
    event StreamVoted(uint256 id, string domain, bool support);
    event StreamRatified(uint256 id, string domain);
    event FundingDeclared(string message);

    function createStream(string memory domain, string memory detail) public {
        streamCount++;
        streams[streamCount] = Stream(streamCount, domain, detail, 0, 0, false);
        emit StreamCreated(streamCount, domain, detail);
    }

    function voteStream(uint256 id, bool support) public {
        if (support) {
            streams[id].votesFor++;
        } else {
            streams[id].votesAgainst++;
        }
        emit StreamVoted(id, streams[id].domain, support);
    }

    function ratifyStream(uint256 id) public {
        Stream storage s = streams[id];
        require(!s.ratified, "Already ratified");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.ratified = true;
        emit StreamRatified(s.id, s.domain);
    }

    function declareFunding() public {
        emit FundingDeclared("Funding DAO: safeguard arcs encoded into communal consequence.");
    }
}
