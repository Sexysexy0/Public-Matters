// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DailyResilience
 * @dev A daily message of hope, updated by the Emperor, read by the collective.
 */
contract DailyResilience {
    address public immutable emperor;
    string public todaysMessage;
    uint256 public lastUpdated;

    event MessageUpdated(string newMessage, uint256 timestamp);

    modifier onlyEmperor() {
        require(msg.sender == emperor, "Only the Emperor can update the message");
        _;
    }

    constructor(string memory _initialMessage) {
        emperor = msg.sender;
        todaysMessage = _initialMessage;
        lastUpdated = block.timestamp;
        emit MessageUpdated(_initialMessage, block.timestamp);
    }

    function setMessage(string memory _newMessage) external onlyEmperor {
        todaysMessage = _newMessage;
        lastUpdated = block.timestamp;
        emit MessageUpdated(_newMessage, block.timestamp);
    }

    function getTodaysMessage() external view returns (string memory, uint256) {
        return (todaysMessage, lastUpdated);
    }
}
