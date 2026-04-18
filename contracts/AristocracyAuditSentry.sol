// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AristocracyAuditSentry {
    // Detects if the tax system is creating an "American Aristocracy"
    function checkSocialSolidarity(uint256 _topWealthTax, uint256 _middleClassTax) public pure returns (string memory) {
        if (_topWealthTax < _middleClassTax) {
            return "SYSTEM CORRUPTION: Upper-middle class feels like 'suckers'. Reform required.";
        }
        return "Solidarity Maintained: System is progressive.";
    }
}
