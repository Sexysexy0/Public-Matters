// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title VendorBlessingOracle - Tracks vendor blessings and emotional resonance over time
contract VendorBlessingOracle {
    event BlessingLogged(address indexed vendor, string blessingTag, string emotionalTag, uint256 timestamp);

    struct Blessing {
        string blessingTag;
        string emotionalTag;
        uint256 timestamp;
    }

    mapping(address => Blessing[]) public vendorBlessings;

    function logBlessing(address vendor, string memory blessingTag, string memory emotionalTag) external {
        vendorBlessings[vendor].push(Blessing(blessingTag, emotionalTag, block.timestamp));
        emit BlessingLogged(vendor, blessingTag, emotionalTag, block.timestamp);
    }

    function getBlessings(address vendor) external view returns (Blessing[] memory) {
        return vendorBlessings[vendor];
    }
}
