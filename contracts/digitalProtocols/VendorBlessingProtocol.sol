// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title VendorBlessingProtocol
/// @notice Certifies vendors based on trust, delivery history, and emotional APR
contract VendorBlessingProtocol {
    struct VendorProfile {
        string name;
        string region;
        bool isBlessed;
        string blessingNote;
        uint256 timestamp;
    }

    mapping(address => VendorProfile) public vendors;
    event VendorBlessed(address vendor, string name, string region, string blessingNote);

    function blessVendor(address vendor, string memory name, string memory region, string memory blessingNote) public {
        vendors[vendor] = VendorProfile(name, region, true, blessingNote, block.timestamp);
        emit VendorBlessed(vendor, name, region, blessingNote);
    }

    function getVendorProfile(address vendor) public view returns (VendorProfile memory) {
        return vendors[vendor];
    }
}
