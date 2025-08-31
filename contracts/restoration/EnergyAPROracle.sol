// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract EnergyAPROracle {
    struct APRFeed {
        string gridType;
        uint256 emotionalYield; // scale 0–100
        string steward;
        uint256 timestamp;
    }

    APRFeed[] public feeds;

    event APRUpdated(string gridType, uint256 emotionalYield, string steward);

    function updateAPR(string memory gridType, uint256 yield, string memory steward) public {
        feeds.push(APRFeed(gridType, yield, steward, block.timestamp));
        emit APRUpdated(gridType, yield, steward);
    }

    function getAPR(uint index) public view returns (string memory, uint256, string memory, uint256) {
        APRFeed memory a = feeds[index];
        return (a.gridType, a.emotionalYield, a.steward, a.timestamp);
    }
}
