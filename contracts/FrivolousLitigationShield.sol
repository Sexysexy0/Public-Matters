// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FrivolousLitigationShield {
    event LitigationSeal(string plaintiff, string caseName, string status);

    function logCase(string memory plaintiff, string memory caseName, bool hasMerit) external {
        string memory status = hasMerit ? "Legitimate" : "Frivolous";
        emit LitigationSeal(plaintiff, caseName, status);
        // RULE: Frivolous lawsuits safeguarded against abuse of legal system.
    }
}
