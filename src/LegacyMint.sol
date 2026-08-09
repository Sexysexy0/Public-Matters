// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LegacyMint is ERC721, Ownable {
    uint256 public nextTokenId;
    bytes32 public immutable manifestoHash;
    string public baseMessage;

    constructor(
        bytes32 _manifestoHash,
        string memory _baseMessage
    ) ERC721("The Bridge", "BRIDGE") Ownable(msg.sender) {
        manifestoHash = _manifestoHash;
        baseMessage = _baseMessage;
    }

    function mintBridge(address _to) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId++;
        _safeMint(_to, tokenId);
        return tokenId;
    }

    function tokenURI(uint256) public pure override returns (string memory) {
        string memory json = string.concat(
            '{"name": "The Bridge", "description": "I crossed. I held on. I made it.",',
            '"attributes": [{"trait_type": "Manifesto", "value": "Genesis"}]}'
        );
        return string.concat("data:application/json;utf8,", json);
    }
}
