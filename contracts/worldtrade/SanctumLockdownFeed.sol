// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumLockdownFeed {
    address public steward;
    mapping(string => bool) public lockdownStatus;

    event LockdownActivated(string sanctum);
    event LockdownLifted(string sanctum);

    constructor() {
        steward = msg.sender;
        lockdownStatus["China"] = true;
        lockdownStatus["Russia"] = true;
        lockdownStatus["India"] = false;
        lockdownStatus["Japan"] = false;
        lockdownStatus["PH"] = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    function activateLockdown(string memory sanctum) public onlySteward {
        lockdownStatus[sanctum] = true;
        emit LockdownActivated(sanctum);
    }

    function liftLockdown(string memory sanctum) public onlySteward {
        lockdownStatus[sanctum] = false;
        emit LockdownLifted(sanctum);
    }

    function isLockedDown(string memory sanctum) public view returns (bool) {
        return lockdownStatus[sanctum];
    }
}
