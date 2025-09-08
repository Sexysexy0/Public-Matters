// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract KinderQueenFirewall {
    address public steward;
    uint public aprThreshold = 80;

    event PacketFiltered(string contentType, bool allowed);

    constructor() {
        steward = msg.sender;
    }

    function filterPacket(uint aprScore, string memory contentType) public returns (bool) {
        bool allowed = aprScore >= aprThreshold;
        emit PacketFiltered(contentType, allowed);
        return allowed;
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        aprThreshold = newThreshold;
    }
}
