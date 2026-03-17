// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PatientRightsNFT {
    uint public tokenCount;
    mapping(uint => address) public ownerOf;
    mapping(address => uint[]) public tokensByOwner;

    event Mint(address indexed to, uint tokenId);

    function mint(address to) public {
        tokenCount++;
        ownerOf[tokenCount] = to;
        tokensByOwner[to].push(tokenCount);
        emit Mint(to, tokenCount);
    }

    function getTokens(address owner) public view returns (uint[] memory) {
        return tokensByOwner[owner];
    }
}
