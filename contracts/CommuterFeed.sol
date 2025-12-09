// contracts/CommuterFeed.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommuterFeed {
    struct Alert {
        string message;
        uint256 timestamp;
    }

    Alert[] public alerts;
    address public owner;

    event AlertBroadcast(string message, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function broadcastAlert(string calldata message) external onlyOwner {
        alerts.push(Alert(message, block.timestamp));
        emit AlertBroadcast(message, block.timestamp);
    }

    function totalAlerts() external view returns (uint256) {
        return alerts.length;
    }
}
