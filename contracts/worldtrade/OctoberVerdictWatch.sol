// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OctoberVerdictWatch {
    uint256 public deadline = 1734172800; // October 14, 2025, 00:00:00 GMT
    bool public alertBroadcasted;

    event CountdownAlert(uint256 daysLeft);
    event VerdictBroadcast(string status);

    function checkDaysLeft() public view returns (uint256) {
        require(block.timestamp < deadline, "Verdict window closed");
        return (deadline - block.timestamp) / 1 days;
    }

    function broadcastAlert() public {
        require(block.timestamp < deadline, "Too late to broadcast");
        uint256 daysLeft = checkDaysLeft();
        emit CountdownAlert(daysLeft);
    }

    function finalizeVerdict(string memory status) public {
        require(block.timestamp >= deadline, "Verdict not yet finalized");
        alertBroadcasted = true;
        emit VerdictBroadcast(status);
    }

    function isBroadcasted() public view returns (bool) {
        return alertBroadcasted;
    }
}
