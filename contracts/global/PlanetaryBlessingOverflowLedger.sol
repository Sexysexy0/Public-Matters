// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetaryBlessingOverflowLedger {
    struct BlessingOverflow {
        string region;
        string blessingType;
        string emotionalAPR;
        uint256 timestamp;
    }

    mapping(string => BlessingOverflow) public overflowLog;

    event OverflowLogged(string region, string blessingType, string emotionalAPR, uint256 timestamp);

    function logOverflow(string memory region, string memory blessingType, string memory emotionalAPR) public {
        overflowLog[region] = BlessingOverflow(region, blessingType, emotionalAPR, block.timestamp);
        emit OverflowLogged(region, blessingType, emotionalAPR, block.timestamp);
    }

    function getOverflow(string memory region) public view returns (BlessingOverflow memory) {
        return overflowLog[region];
    }
}
