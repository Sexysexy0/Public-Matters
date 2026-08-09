// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ContentOwnershipRegistry is ERC721, Ownable {
    uint256 public nextTokenId;

    struct Content {
        string title;
        string creator;
        string mediaHash; // IPFS or Arweave hash of the actual file
        uint256 price; // Original purchase price (wei)
        uint256 royaltyBps; // Royalty in basis points (e.g., 500 = 5%)
        address payable creatorAddress;
        uint256 totalSales;
    }

    mapping(uint256 => Content) public contents;

    event ContentRegistered(uint256 indexed id, string title, address creator, uint256 price, uint256 royalty);
    event ContentSold(uint256 indexed id, address from, address to, uint256 price);

    constructor() ERC721("Content Ownership", "CONTENT") Ownable(msg.sender) {}

    // Register a new content piece (only owner/architect can approve)
    function registerContent(
        string memory _title,
        string memory _creator,
        string memory _mediaHash,
        uint256 _price,
        uint256 _royaltyBps,
        address payable _creatorAddress
    ) external onlyOwner returns (uint256) {
        require(_price > 0, "Price must be > 0");
        require(_royaltyBps <= 1000, "Royalty max 10%");
        require(_creatorAddress != address(0), "Invalid creator");

        uint256 tokenId = nextTokenId++;
        // Mint the first copy to the creator (they own it initially)
        _safeMint(_creatorAddress, tokenId);

        contents[tokenId] = Content({
            title: _title,
            creator: _creator,
            mediaHash: _mediaHash,
            price: _price,
            royaltyBps: _royaltyBps,
            creatorAddress: _creatorAddress,
            totalSales: 0
        });

        emit ContentRegistered(tokenId, _title, _creatorAddress, _price, _royaltyBps);
        return tokenId;
    }

    // Buy a content token from its current owner
    function buyContent(uint256 _tokenId) external payable {
        Content storage content = contents[_tokenId];
        address currentOwner = ownerOf(_tokenId);
        require(currentOwner != address(0), "Token does not exist");
        require(msg.sender != currentOwner, "Already owner");
        require(msg.value >= content.price, "Insufficient payment");

        // Calculate royalty
        uint256 royalty = (msg.value * content.royaltyBps) / 10000;
        uint256 sellerProceeds = msg.value - royalty;

        // Pay creator (royalty) and seller (proceeds)
        content.creatorAddress.transfer(royalty);
        payable(currentOwner).transfer(sellerProceeds);

        // Transfer the NFT
        _transfer(currentOwner, msg.sender, _tokenId);
        content.price = msg.value; // update price to the new purchase price (optional, can be fixed)
        content.totalSales++;

        emit ContentSold(_tokenId, currentOwner, msg.sender, msg.value);
    }

    // Allow creators to update price (optional)
    function setPrice(uint256 _tokenId, uint256 _newPrice) external {
        require(ownerOf(_tokenId) == msg.sender || msg.sender == owner(), "Not owner or admin");
        contents[_tokenId].price = _newPrice;
    }

    // Get content info
    function getContent(uint256 _tokenId)
        external
        view
        returns (
            string memory title,
            string memory creator,
            string memory mediaHash,
            uint256 price,
            uint256 royaltyBps,
            address creatorAddress,
            uint256 totalSales
        )
    {
        Content memory c = contents[_tokenId];
        return (c.title, c.creator, c.mediaHash, c.price, c.royaltyBps, c.creatorAddress, c.totalSales);
    }
}
