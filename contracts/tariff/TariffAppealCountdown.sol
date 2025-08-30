// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TariffAppealCountdown {
    uint256 public appealDeadline;
    bool public restorationReady;

    constructor(uint256 _appealDeadline) {
        appealDeadline = _appealDeadline;
        restorationReady = false;
    }

    function checkCountdown() public view returns (uint256 daysLeft) {
        require(block.timestamp < appealDeadline, "Deadline passed");
        daysLeft = (appealDeadline - block.timestamp) / 1 days;
    }

    function activateRestoration() public {
        require(block.timestamp >= appealDeadline, "Appeal window still open");
        restorationReady = true;
    }

    function isRestorationReady() public view returns (bool) {
        return restorationReady;
    }
}
