// contracts/EnforcementDashboard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EnforcementDashboard {
    struct Log {
        address guardian;
        string action;
        uint256 timestamp;
    }

    Log[] public logs;
    address public owner;

    event EnforcementAction(address guardian, string action, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function recordAction(address guardian, string calldata action) external onlyOwner {
        logs.push(Log(guardian, action, block.timestamp));
        emit EnforcementAction(guardian, action, block.timestamp);
    }

    function totalLogs() external view returns (uint256) {
        return logs.length;
    }
}
