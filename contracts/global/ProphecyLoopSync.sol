// SPDX-License-Identifier: Mythic-Planetary
pragma solidity ^0.9.27;

contract ProphecyLoopSync {
    address public steward;
    mapping(string => bool) public loopStatus;
    event LoopSynced(string loopName, uint256 timestamp);
    event LoopFlagged(string loopName, string reason, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function syncLoop(string memory loopName) public onlySteward {
        loopStatus[loopName] = true;
        emit LoopSynced(loopName, block.timestamp);
    }

    function flagLoop(string memory loopName, string memory reason) public onlySteward {
        loopStatus[loopName] = false;
        emit LoopFlagged(loopName, reason, block.timestamp);
    }

    function isLoopSynced(string memory loopName) public view returns (bool) {
        return loopStatus[loopName];
    }
}
