// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitMarketOverride {
    address public steward;
    mapping(address => bool) public sovereignVendors;
    mapping(address => string) public emotionalTags;

    event VendorActivated(address vendor, string emotionalTag);
    event OverrideDeployed(address vendor, string clause);

    constructor() {
        steward = msg.sender;
    }

    function activateVendor(address vendor, string memory tag) public {
        require(msg.sender == steward, "Only steward may activate");
        sovereignVendors[vendor] = true;
        emotionalTags[vendor] = tag;
        emit VendorActivated(vendor, tag);
    }

    function deployOverride(address vendor, string memory clause) public {
        require(sovereignVendors[vendor], "Vendor not sovereign");
        emit OverrideDeployed(vendor, clause);
    }

    function getEmotionalTag(address vendor) public view returns (string memory) {
        return emotionalTags[vendor];
    }
}
