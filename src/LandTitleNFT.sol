// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LandTitleNFT is ERC721, Ownable {
    uint256 public nextTokenId;

    struct Title {
        string location; // Barangay / City
        string lotNumber; // Official lot identifier
        bytes32 documentHash; // Hash of the original physical title
        address currentOwner;
        uint256 transferDate;
    }

    mapping(uint256 => Title) public titles;

    event TitleIssued(uint256 indexed id, address owner, string location);
    event TitleTransferred(uint256 indexed id, address from, address to);

    constructor() ERC721("Land Title", "TITLE") Ownable(msg.sender) {}

    // Issue a new title to a citizen (only by the owner/architect)
    function issueTitle(address _owner, string memory _location, string memory _lotNumber, bytes32 _documentHash)
        external
        onlyOwner
        returns (uint256)
    {
        require(_owner != address(0), "Invalid owner");
        require(bytes(_location).length > 0, "Location required");

        uint256 tokenId = nextTokenId++;
        _safeMint(_owner, tokenId);

        titles[tokenId] = Title({
            location: _location,
            lotNumber: _lotNumber,
            documentHash: _documentHash,
            currentOwner: _owner,
            transferDate: block.timestamp
        });

        emit TitleIssued(tokenId, _owner, _location);
        return tokenId;
    }

    // Transfer title (standard ERC721 transfer, but we also update the Title struct)
    function transferTitle(address _to, uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(_to != address(0), "Invalid recipient");

        _transfer(msg.sender, _to, _tokenId);

        Title storage title = titles[_tokenId];
        title.currentOwner = _to;
        title.transferDate = block.timestamp;

        emit TitleTransferred(_tokenId, msg.sender, _to);
    }

    // Get full title info (for barangay verification)
    function getTitle(uint256 _tokenId)
        external
        view
        returns (
            string memory location,
            string memory lotNumber,
            bytes32 documentHash,
            address currentOwner,
            uint256 transferDate
        )
    {
        Title memory title = titles[_tokenId];
        return (title.location, title.lotNumber, title.documentHash, title.currentOwner, title.transferDate);
    }
}
