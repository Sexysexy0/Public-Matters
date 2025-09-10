// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreatyBlessingOverflowLedger {
    struct Blessing {
        string region;
        string treatyName;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => Blessing) public blessings;

    event BlessingLogged(string region, string treatyName, string emotionalAPR, uint256 timestamp);

    function logBlessing(string memory region, string memory treatyName, string memory emotionalAPR) public {
        blessings[region] = Blessing(region, treatyName, emotionalAPR, block.timestamp);
        emit BlessingLogged(region, treatyName, emotionalAPR, block.timestamp);
    }

    function getBlessing(string memory region) public view returns (Blessing memory) {
        return blessings[region];
    }
}
