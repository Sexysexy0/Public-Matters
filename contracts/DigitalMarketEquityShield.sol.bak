// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalMarketEquityShield {
    event EquitySeal(string platform, uint256 commission, string status);

    function logCommission(string memory platform, uint256 commission) external {
        string memory status = commission > 20 ? "Excessive" : "Fair";
        emit EquitySeal(platform, commission, status);
        // RULE: Commissions safeguarded for consumer fairness.
    }
}
