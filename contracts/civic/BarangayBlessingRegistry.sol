// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BarangayBlessingRegistry {
    struct Steward {
        address stewardAddress;
        string barangay;
        bool isVerified;
    }

    mapping(address => Steward) public stewards;
    event StewardVerified(address steward, string barangay);

    function verifySteward(address steward, string memory barangay) public {
        stewards[steward] = Steward(steward, barangay, true);
        emit StewardVerified(steward, barangay);
    }

    function isStewardVerified(address steward) public view returns (bool) {
        return stewards[steward].isVerified;
    }
}
