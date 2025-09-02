// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangayBlessingProtocol {
    struct Blessing {
        string barangay;
        string emotion;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event BlessingTagged(string barangay, string emotion, uint256 timestamp);

    function tagBlessing(string memory barangay, string memory emotion) public {
        blessings.push(Blessing(barangay, emotion, block.timestamp));
        emit BlessingTagged(barangay, emotion, block.timestamp);
    }

    function getBlessings() public view returns (Blessing[] memory) {
        return blessings;
    }
}
