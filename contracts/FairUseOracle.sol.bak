// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FairUseOracle {
    event FairUseRecord(address account, string issue);

    function logFairUse(address _account, string memory _issue) external {
        emit FairUseRecord(_account, _issue);
        // ORACLE: Fair use monitored to prevent abuse of sharing.
    }
}
