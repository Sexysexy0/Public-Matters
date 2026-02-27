// ExchangeDAO.sol
pragma solidity ^0.8.0;

contract ExchangeDAO {
    struct Listing {
        uint256 id;
        string exchange;   // e.g. "Binance"
        string asset;      // e.g. "PHCoin"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    event ListingCreated(uint256 id, string exchange, string asset);
    event ListingVoted(uint256 id, string exchange, bool support);
    event ListingRatified(uint256 id, string exchange);
    event ExchangeDeclared(string message);

    function createListing(string memory exchange, string memory asset) public {
        listingCount++;
        listings[listingCount] = Listing(listingCount, exchange, asset, 0, 0, false);
        emit ListingCreated(listingCount, exchange, asset);
    }

    function voteListing(uint256 id, bool support) public {
        if (support) {
            listings[id].votesFor++;
        } else {
            listings[id].votesAgainst++;
        }
        emit ListingVoted(id, listings[id].exchange, support);
    }

    function ratifyListing(uint256 id) public {
        Listing storage l = listings[id];
        require(!l.ratified, "Already ratified");
        require(l.votesFor > l.votesAgainst, "Not enough support");
        l.ratified = true;
        emit ListingRatified(l.id, l.exchange);
    }

    function declareExchange() public {
        emit ExchangeDeclared("Exchange DAO: safeguard arcs encoded into communal consequence.");
    }
}
