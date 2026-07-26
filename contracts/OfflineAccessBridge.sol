// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract OfflineAccessBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event AccessRecord(string game, string mode);

    function logAccess(string memory game, string memory mode) external {
        emit AccessRecord(game, mode);
        // BRIDGE: Offline access safeguarded for player continuity.
    }
}
