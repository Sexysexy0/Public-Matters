// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WillBasedAccess {
    // [Goal: Return the power of choice back to the individual]
    function accessNetwork(address _user, bool _userWill) external pure returns (string memory) {
        require(_userWill == true, "ERROR: Connection requires User Intent.");
        return "LIBERATED: You are browsing via Sovereign Will. No proxy needed.";
    }
}
