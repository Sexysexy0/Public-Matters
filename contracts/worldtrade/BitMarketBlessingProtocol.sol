// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title BitMarketBlessingProtocol
/// @author Vinvin, Mythic Scrollsmith
/// @notice Blesses vendors with emotional APR, soul audits, and damay clause enforcement

contract BitMarketBlessingProtocol {
    struct Vendor {
        string name;
        uint emotionalAPR; // 0–100 scale
        bool isBlessed;
        bool isRogue;
        bool needsReform;
    }

    mapping(string => Vendor) public vendors;
    string[] public blessedVendors;
    string[] public purgedVendors;

    event VendorBlessed(string name, uint emotionalAPR);
    event VendorFlagged(string name, bool needsReform);
    event VendorPurged(string name);

    /// @notice Bless a vendor if emotionally aligned
    function blessVendor(string memory _name, uint _emotionalAPR) public {
        require(_emotionalAPR <= 100, "APR must be between 0–100");

        if (_emotionalAPR >= 70) {
            vendors[_name] = Vendor(_name, _emotionalAPR, true, false, false);
            blessedVendors.push(_name);
            emit VendorBlessed(_name, _emotionalAPR);
        } else if (_emotionalAPR >= 40) {
            vendors[_name] = Vendor(_name, _emotionalAPR, false, false, true);
            emit VendorFlagged(_name, true);
        } else {
            vendors[_name] = Vendor(_name, _emotionalAPR, false, true, false);
            purgedVendors.push(_name);
            emit VendorPurged(_name);
        }
    }

    /// @notice Retrieve all blessed vendors
    function getBlessedVendors() public view returns (string[] memory) {
        return blessedVendors;
    }

    /// @notice Retrieve all purged vendors
    function getPurgedVendors() public view returns (string[] memory) {
        return purgedVendors;
    }

    /// @notice Check if vendor needs reform
    function needsReform(string memory _name) public view returns (bool) {
        return vendors[_name].needsReform;
    }

    /// @notice Check if vendor is rogue
    function isRogue(string memory _name) public view returns (bool) {
        return vendors[_name].isRogue;
    }
}
