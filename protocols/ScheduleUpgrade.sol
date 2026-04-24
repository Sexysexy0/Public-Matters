// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ScheduleUpgrade {
    enum Status { Restricted, Medical, Essential }
    Status public sovereignStatus = Status.Restricted;

    // [Goal: Reclassify the Sovereign's professional status to unlock higher opportunities]
    function upgradeStatus() external {
        sovereignStatus = Status.Medical; // [Now recognized as a 'Value-Added' Asset]
    }
}
