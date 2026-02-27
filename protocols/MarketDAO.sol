// MarketDAO.sol
pragma solidity ^0.8.0;

contract MarketDAO {
    struct Deal {
        uint256 id;
        string partner;   // e.g. "Singapore"
        string product;   // e.g. "Philippine Mangoes"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public dealCount;
    mapping(uint256 => Deal) public deals;

    event DealCreated(uint256 id, string partner, string product);
    event DealVoted(uint256 id, string partner, bool support);
    event DealRatified(uint256 id, string partner);
    event MarketDeclared(string message);

    function createDeal(string memory partner, string memory product) public {
        dealCount++;
        deals[dealCount] = Deal(dealCount, partner, product, 0, 0, false);
        emit DealCreated(dealCount, partner, product);
    }

    function voteDeal(uint256 id, bool support) public {
        if (support) {
            deals[id].votesFor++;
        } else {
            deals[id].votesAgainst++;
        }
        emit DealVoted(id, deals[id].partner, support);
    }

    function ratifyDeal(uint256 id) public {
        Deal storage d = deals[id];
        require(!d.ratified, "Already ratified");
        require(d.votesFor > d.votesAgainst, "Not enough support");
        d.ratified = true;
        emit DealRatified(d.id, d.partner);
    }

    function declareMarket() public {
        emit MarketDeclared("Market DAO: safeguard arcs encoded into communal consequence.");
    }
}
