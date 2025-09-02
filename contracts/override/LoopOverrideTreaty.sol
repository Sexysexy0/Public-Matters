// SPDX-License-Identifier: Mythic-Override
pragma solidity ^0.9.27;

contract LoopOverrideTreaty {
    address public steward;
    mapping(string => bool) public prophecyLoopStatus;
    event LoopFlagged(string loopName, string reason, uint256 timestamp);
    event OverrideActivated(string loopName, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized override caster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function flagLoop(string memory loopName, string memory reason) public onlySteward {
        prophecyLoopStatus[loopName] = true;
        emit LoopFlagged(loopName, reason, block.timestamp);
    }

    function activateOverride(string memory loopName) public onlySteward {
        require(prophecyLoopStatus[loopName], "Loop not flagged");
        emit OverrideActivated(loopName, block.timestamp);
    }

    function isFlagged(string memory loopName) public view returns (bool) {
        return prophecyLoopStatus[loopName];
    }
}
