// CommunityDAO.sol
pragma solidity ^0.8.0;

contract CommunityDAO {
    struct Link {
        uint256 id;
        string domain;    // e.g. "Chat Rooms"
        string detail;    // e.g. "Organic connections and discovery"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public linkCount;
    mapping(uint256 => Link) public links;

    event LinkCreated(uint256 id, string domain, string detail);
    event LinkVoted(uint256 id, string domain, bool support);
    event LinkRatified(uint256 id, string domain);
    event CommunityDeclared(string message);

    function createLink(string memory domain, string memory detail) public {
        linkCount++;
        links[linkCount] = Link(linkCount, domain, detail, 0, 0, false);
        emit LinkCreated(linkCount, domain, detail);
    }

    function voteLink(uint256 id, bool support) public {
        if (support) {
            links[id].votesFor++;
        } else {
            links[id].votesAgainst++;
        }
        emit LinkVoted(id, links[id].domain, support);
    }

    function ratifyLink(uint256 id) public {
        Link storage l = links[id];
        require(!l.ratified, "Already ratified");
        require(l.votesFor > l.votesAgainst, "Not enough support");
        l.ratified = true;
        emit LinkRatified(l.id, l.domain);
    }

    function declareCommunity() public {
        emit CommunityDeclared("Community DAO: safeguard arcs encoded into communal consequence.");
    }
}
