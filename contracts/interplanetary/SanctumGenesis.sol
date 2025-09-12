// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumGenesis {
    struct HQ {
        uint256 id;
        string planet;
        string coordinates;
        string civicRitual;
        uint256 timestamp;
    }

    mapping(uint256 => HQ) public hqRegistry;
    uint256 public hqCount;

    event HQDeployed(uint256 id, string planet, string coordinates);

    function deployHQ(
        string memory planet,
        string memory coordinates,
        string memory civicRitual,
        uint256 timestamp
    ) public {
        hqRegistry[hqCount] = HQ(hqCount, planet, coordinates, civicRitual, timestamp);
        emit HQDeployed(hqCount, planet, coordinates);
        hqCount++;
    }

    function getHQ(uint256 id) public view returns (HQ memory) {
        return hqRegistry[id];
    }
}
