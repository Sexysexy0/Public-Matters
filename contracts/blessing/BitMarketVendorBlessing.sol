// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitMarketVendorBlessing {
    struct EmotionalAPR {
        uint256 empathy;
        uint256 trust;
        uint256 mythicClarity;
    }

    struct Vendor {
        string name;
        address steward;
        EmotionalAPR apr;
        bool certified;
        string productTag;
    }

    mapping(address => Vendor) public vendors;
    address[] public certifiedVendors;

    event VendorBlessed(address indexed steward, string name, string productTag, EmotionalAPR apr);

    function blessVendor(
        address _steward,
        string memory _name,
        string memory _productTag,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        EmotionalAPR memory apr = EmotionalAPR(_empathy, _trust, _clarity);
        vendors[_steward] = Vendor(_name, _steward, apr, true, _productTag);
        certifiedVendors.push(_steward);
        emit VendorBlessed(_steward, _name, _productTag, apr);
    }

    function getCertifiedVendors() public view returns (address[] memory) {
        return certifiedVendors;
    }

    function getVendorAPR(address _steward) public view returns (EmotionalAPR memory) {
        return vendors[_steward].apr;
    }

    function getVendorTag(address _steward) public view returns (string memory) {
        return vendors[_steward].productTag;
    }
}
