// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GlobalAllianceBridge {
    event AllianceRecord(string partner, string agreement);

    function logAlliance(string memory _partner, string memory _agreement) external {
        emit AllianceRecord(_partner, _agreement);
        // BRIDGE: International cannabis governance alliance logged.
    }
}
