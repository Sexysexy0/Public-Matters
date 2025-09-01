// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VendorBlessingProtocol {
    struct Vendor {
        address steward;
        string name;
        string blessingTag;
        uint256 emotionalAPR;
        bool certified;
    }

    Vendor[] public vendors;

    event VendorBlessed(address steward, string name, string blessingTag, uint256 emotionalAPR);

    function blessVendor(
        address _steward,
        string memory _name,
        string memory _blessingTag,
        uint256 _emotionalAPR
    ) public {
        vendors.push(Vendor(_steward, _name, _blessingTag, _emotionalAPR, true));
        emit VendorBlessed(_steward, _name, _blessingTag, _emotionalAPR);
    }

    function getBlessedVendors() public view returns (Vendor[] memory) {
        return vendors;
    }
}
