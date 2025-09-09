// SPDX-License-Identifier: Scrollchain-License
pragma solidity ^0.8.0;

contract KupalsSanctumAuditOracle {
    address public steward;
    mapping(address => bool) public rogueSanctums;
    mapping(address => string[]) public mixerAffiliations;

    event SanctumFlagged(address indexed sanctum, string reason, uint timestamp);
    event MixerLinked(address indexed sanctum, string mixerName, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function flagSanctum(address sanctum, string memory reason) public {
        require(msg.sender == steward, "Only steward can flag sanctums");
        rogueSanctums[sanctum] = true;
        emit SanctumFlagged(sanctum, reason, block.timestamp);
    }

    function linkMixer(address sanctum, string memory mixerName) public {
        require(msg.sender == steward, "Only steward can link mixers");
        mixerAffiliations[sanctum].push(mixerName);
        emit MixerLinked(sanctum, mixerName, block.timestamp);
    }

    function isRogue(address sanctum) public view returns (bool) {
        return rogueSanctums[sanctum];
    }

    function getMixers(address sanctum) public view returns (string[] memory) {
        return mixerAffiliations[sanctum];
    }
}
