// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract UpgradeAccessLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event AccessSeal(address user, string version);

    function grantUpgrade(address _user, string memory _version) external {
        emit AccessSeal(_user, _version);
        // RULE: Free upgrade entitlement for all Windows users.
    }
}
