// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VendorBlessingProtocol {
    struct Vendor {
        string tribe;
        string product;
        string certificationAgency; // e.g. "DTI", "NCIP", "DA", "PS-DBM"
        bool isBlessed;
        string emotionalTag; // e.g. "BlessedFlow", "AncestorGlow", "AuditGlow"
        uint256 timestamp;
    }

    Vendor[] public vendors;

    event VendorBlessed(string tribe, string product, string certificationAgency, string emotionalTag);

    function blessVendor(
        string memory _tribe,
        string memory _product,
        string memory _certificationAgency,
        bool _isBlessed,
        string memory _emotionalTag
    ) public {
        vendors.push(Vendor(_tribe, _product, _certificationAgency, _isBlessed, _emotionalTag, block.timestamp));
        emit VendorBlessed(_tribe, _product, _certificationAgency, _emotionalTag);
    }

    function getVendor(uint256 index) public view returns (Vendor memory) {
        return vendors[index];
    }

    function totalVendors() public view returns (uint256) {
        return vendors.length;
    }
}
