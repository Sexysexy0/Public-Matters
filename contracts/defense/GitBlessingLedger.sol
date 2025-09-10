// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GitBlessingLedger {
    struct Blessing {
        string commitHash;
        string emotionalAPR;
        string sanctumImpact;
        uint256 timestamp;
    }

    mapping(string => Blessing) public blessings;

    event BlessingLogged(string commitHash, string emotionalAPR, string sanctumImpact, uint256 timestamp);

    function logBlessing(string memory commitHash, string memory emotionalAPR, string memory sanctumImpact) public {
        blessings[commitHash] = Blessing(commitHash, emotionalAPR, sanctumImpact, block.timestamp);
        emit BlessingLogged(commitHash, emotionalAPR, sanctumImpact, block.timestamp);
    }

    function getBlessing(string memory commitHash) public view returns (Blessing memory) {
        return blessings[commitHash];
    }
}
