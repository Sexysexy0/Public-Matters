// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DependencyMonitor
 * @dev Emits a signal when a critical dependency is detected.
 *      The Emperor (or a bot) listens for the signal and manually pauses the Anchor.
 */
contract DependencyMonitor {
    address public immutable emperor;
    bytes32 public currentDependencyHash;

    event HashUpdated(bytes32 newHash);
    event CriticalDependencyDetected(string message);

    modifier onlyEmperor() {
        require(msg.sender == emperor, "Only the emperor");
        _;
    }

    constructor(bytes32 _initialHash) {
        emperor = msg.sender;
        currentDependencyHash = _initialHash;
    }

    function updateHash(bytes32 _newHash) external onlyEmperor {
        currentDependencyHash = _newHash;
        emit HashUpdated(_newHash);
    }

    // Emit a signal that a critical vulnerability is detected.
    // The Emperor or a bot will listen to this event and pause the Anchor.
    function reportCriticalDependency(string calldata _message) external onlyEmperor {
        emit CriticalDependencyDetected(_message);
    }
}
