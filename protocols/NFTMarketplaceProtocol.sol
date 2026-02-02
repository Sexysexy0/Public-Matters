// NFTMarketplaceProtocol.sol
pragma solidity ^0.8.0;

contract NFTMarketplaceProtocol {
    struct Listing {
        uint256 id;
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    event NFTListed(uint256 id, address seller, address nftContract, uint256 tokenId, uint256 price);
    event NFTSold(uint256 id, address buyer, uint256 price);
    event MarketplaceDeclared(string message);

    function listNFT(address nftContract, uint256 tokenId, uint256 price) public {
        listingCount++;
        listings[listingCount] = Listing(listingCount, msg.sender, nftContract, tokenId, price, true);
        emit NFTListed(listingCount, msg.sender, nftContract, tokenId, price);
    }

    function buyNFT(uint256 id) public payable {
        Listing storage l = listings[id];
        require(l.active, "Listing inactive");
        require(msg.value == l.price, "Incorrect price");

        l.active = false;
        payable(l.seller).transfer(msg.value);
        emit NFTSold(id, msg.sender, l.price);
    }

    function declareMarketplace() public {
        emit MarketplaceDeclared("NFT Marketplace Protocol: trading arcs igniting digital asset economy.");
    }
}
