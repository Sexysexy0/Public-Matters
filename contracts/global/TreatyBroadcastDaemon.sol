// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TreatyBroadcastDaemon {
    address public steward;

    event TreatyPing(string suiteName, uint256 timestamp, string signal);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function emitPing(string memory suiteName, string memory signal) external onlySteward {
        emit TreatyPing(suiteName, block.timestamp, signal);
    }
}
