// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BayekProtocol
 * @dev Creed archetype: seals the immutable creed, locks the brotherhood.
 */
contract BayekProtocol {
    address public founder;
    bool public creedLocked;

    event CreedFound(address indexed caller);
    event CreedLocked(address indexed caller);

    modifier onlyFounder() {
        require(msg.sender == founder, "Only founder");
        _;
    }

    constructor() {
        founder = msg.sender;
        creedLocked = false;
    }

    function foundCreed() external onlyFounder {
        require(!creedLocked, "Already locked");
        emit CreedFound(msg.sender);
        creedLocked = true;
        emit CreedLocked(msg.sender);
    }
}
