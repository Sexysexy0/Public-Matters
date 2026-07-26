// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UpdateBridge is Ownable {

    constructor() Ownable(msg.sender) {}

    event UpdateRecord(string version, string improvement);

    function logUpdate(string memory _version, string memory _improvement) external {
        emit UpdateRecord(_version, _improvement);
        // BRIDGE: Proton updates logged for governance.
    }
}
