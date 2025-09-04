// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BarangayBlessingProtocol - Ritualized Barangay Validation & Deployment Suite
/// @author Vinvin
/// @notice Blesses barangays, validates stewards, and tags emotional resonance.

contract BarangayBlessingProtocol {
    address public steward;
    mapping(string => bool) public blessedBarangays;
    mapping(address => string) public stewardBarangay;

    event BarangayBlessed(string barangayName);
    event StewardTagged(address steward, string barangayName);

    constructor() {
        steward = msg.sender;
    }

    function blessBarangay(string calldata _barangayName) external {
        require(msg.sender == steward, "Only steward may bless.");
        blessedBarangays[_barangayName] = true;
        emit BarangayBlessed(_barangayName);
    }

    function tagSteward(address _steward, string calldata _barangayName) external {
        require(blessedBarangays[_barangayName], "Barangay not blessed.");
        stewardBarangay[_steward] = _barangayName;
        emit StewardTagged(_steward, _barangayName);
    }

    function getStewardBarangay(address _steward) external view returns (string memory) {
        return stewardBarangay[_steward];
    }
}
