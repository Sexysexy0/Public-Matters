// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameResaleEscrow {
    struct Listing {
        address seller;
        uint256 price;
        address developerAddress;
        uint96 royaltyBps;
    }

    mapping(uint256 => Listing) public listings;

    event GameListed(uint256 indexed tokenId, uint256 price, address seller);
    event GameSold(uint256 indexed tokenId, address buyer, uint256 price);

    function listGameForResale(uint256 tokenId, uint256 price, address developer, uint96 royaltyBps) external {
        require(price > 0, "Price must be > 0");
        require(royaltyBps <= 1000, "Royalty capped at 10%");

        listings[tokenId] = Listing({
            seller: msg.sender,
            price: price,
            developerAddress: developer,
            royaltyBps: royaltyBps
        });

        emit GameListed(tokenId, price, msg.sender);
    }

    function buyResaleGame(uint256 tokenId) external payable {
        Listing memory item = listings[tokenId];
        require(item.price > 0, "Game not listed");
        require(msg.value >= item.price, "Insufficient payment");

        uint256 royaltyAmount = (item.price * item.royaltyBps) / 10000;
        uint256 sellerAmount = item.price - royaltyAmount;

        delete listings[tokenId];

        payable(item.developerAddress).transfer(royaltyAmount);
        payable(item.seller).transfer(sellerAmount);

        if (msg.value > item.price) {
            payable(msg.sender).transfer(msg.value - item.price);
        }

        emit GameSold(tokenId, msg.sender, item.price);
    }
}
