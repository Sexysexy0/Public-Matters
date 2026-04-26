// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract VersioningShield {
    event VersionSeal(string modName, string status);

    function logVersion(string memory modName, bool preserved) external {
        string memory status = preserved ? "Legacy Preserved" : "Overwritten";
        emit VersionSeal(modName, status);
        // RULE: Legacy mod versions safeguarded against forced overwrites.
    }
}
