// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CamSwitchBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event SwitchRecord(string fromCam, string toCam);

    function logSwitch(string memory _fromCam, string memory _toCam) external {
        emit SwitchRecord(_fromCam, _toCam);
        // BRIDGE: Camera switching logged for governance.
    }
}
