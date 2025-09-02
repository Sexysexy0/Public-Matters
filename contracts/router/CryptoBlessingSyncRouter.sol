// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoBlessingSyncRouter {
    address public steward;
    mapping(address => uint256) public blessingScore;
    mapping(address => string) public vendorTag;

    event BlessingSynced(address vendor, uint256 score, string tag);

    constructor() {
        steward = msg.sender;
    }

    function syncBlessing(address vendor, uint256 score, string memory tag) public {
        require(msg.sender == steward, "Only steward may sync");
        blessingScore[vendor] += score;
        vendorTag[vendor] = tag;
        emit BlessingSynced(vendor, score, tag);
    }

    function getBlessingScore(address vendor) public view returns (uint256) {
        return blessingScore[vendor];
    }

    function getVendorTag(address vendor) public view returns (string memory) {
        return vendorTag[vendor];
    }
}
