// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CastleAccess is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Access Restricted High-Value Regions]
    function verifyEntry(uint256 _hygieneLevel, string memory _outfitType) external pure returns (bool) {
        // Logic: Must be Clean AND wearing 'Noble' or 'Formal' gear.
        return (_hygieneLevel >= 80 && keccak256(abi.encodePacked(_outfitType)) == keccak256(abi.encodePacked("Formal")));
    }
}
