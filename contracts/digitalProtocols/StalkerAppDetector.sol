// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StalkerAppDetector {
    mapping(string => bool) public flaggedApps;

    function flagApp(string memory appName) public {
        flaggedApps[appName] = true;
    }

    function unflagApp(string memory appName) public {
        flaggedApps[appName] = false;
    }

    function isStalkerApp(string memory appName) public view returns (bool) {
        return flaggedApps[appName];
    }
}
