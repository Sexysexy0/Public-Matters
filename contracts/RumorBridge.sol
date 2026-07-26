// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RumorBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event RumorRecord(string source, string detail);

    function logRumor(string memory source, string memory detail) external {
        emit RumorRecord(source, detail);
        // BRIDGE: Rumors logged to safeguard transparency and prevent exploitative speculation.
    }
}
