// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BarangayBlessingSync
/// @dev Syncs barangay blessing status, emotional APR, and override triggers

contract BarangayBlessingSync {
    struct BarangayStatus {
        bool synced;
        uint256 blessedFarmers;
        string emotionalAPR;
        bool overrideTriggered;
    }

    mapping(string => BarangayStatus) public barangayLedger;
    address public steward;

    event BarangaySynced(string indexed name, uint256 blessedFarmers, string emotionalAPR, bool overrideTriggered);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncBarangay(string memory name, uint256 farmers, string memory apr, bool overrideFlag) public onlySteward {
        barangayLedger[name] = BarangayStatus(true, farmers, apr, overrideFlag);
        emit BarangaySynced(name, farmers, apr, overrideFlag);
    }

    function getBarangayStatus(string memory name) public view returns (BarangayStatus memory) {
        return barangayLedger[name];
    }
}
