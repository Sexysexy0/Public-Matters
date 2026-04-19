// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalSanctionOracle {
    // [MESSAGE: "keep such evil in power... WHY NOT"]
    function auditDeal(uint256 _humanRightsScore) public pure returns (string memory) {
        if (_humanRightsScore < 10) { // Scale 1-100
            return "SIGNAL: BLOCK DEAL. Funding an oppressive regime is a systemic threat to humanity.";
        }
        return "SIGNAL: Monitor and Proceed.";
    }
}
