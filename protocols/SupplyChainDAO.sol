// SupplyChainDAO.sol
pragma solidity ^0.8.0;

contract SupplyChainDAO {
    struct Link {
        uint256 id;
        string sector;    // e.g. "Logistics"
        string detail;    // e.g. "Diesel trucks delivering goods"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public linkCount;
    mapping(uint256 => Link) public links;

    event LinkCreated(uint256 id, string sector, string detail);
    event LinkVoted(uint256 id, string sector, bool support);
    event LinkRatified(uint256 id, string sector);
    event SupplyChainDeclared(string message);

    function createLink(string memory sector, string memory detail) public {
        linkCount++;
        links[linkCount] = Link(linkCount, sector, detail, 0, 0, false);
        emit LinkCreated(linkCount, sector, detail);
    }

    function voteLink(uint256 id, bool support) public {
        if (support) {
            links[id].votesFor++;
        } else {
            links[id].votesAgainst++;
        }
        emit LinkVoted(id, links[id].sector, support);
    }

    function ratifyLink(uint256 id) public {
        Link storage l = links[id];
        require(!l.ratified, "Already ratified");
        require(l.votesFor > l.votesAgainst, "Not enough support");
        l.ratified = true;
        emit LinkRatified(l.id, l.sector);
    }

    function declareSupplyChain() public {
        emit SupplyChainDeclared("SupplyChain DAO: safeguard arcs encoded into communal consequence.");
    }
}
