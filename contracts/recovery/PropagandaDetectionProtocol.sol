// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.8.19;

contract PropagandaDetectionProtocol {
    address public steward;
    mapping(string => bool) public flaggedScrolls;

    event ScrollFlagged(string scrollHash, string reason);
    event ScrollCleared(string scrollHash);

    constructor() {
        steward = msg.sender;
    }

    function flagScroll(string memory scrollHash, string memory reason) public {
        require(msg.sender == steward, "Only steward may flag");
        flaggedScrolls[scrollHash] = true;
        emit ScrollFlagged(scrollHash, reason);
    }

    function clearScroll(string memory scrollHash) public {
        require(msg.sender == steward, "Only steward may clear");
        flaggedScrolls[scrollHash] = false;
        emit ScrollCleared(scrollHash);
    }

    function isFlagged(string memory scrollHash) public view returns (bool) {
        return flaggedScrolls[scrollHash];
    }
}
