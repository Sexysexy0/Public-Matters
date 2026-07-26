// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FlashPrepBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event PrepRecord(string device, string step);

    function logPrep(string memory _device, string memory _step) external {
        emit PrepRecord(_device, _step);
        // BRIDGE: Pre-flash preparation logged for governance.
    }
}
