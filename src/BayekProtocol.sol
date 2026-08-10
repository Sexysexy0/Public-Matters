// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BayekProtocol (Brick #30)
 * @dev Establishes and locks immutable Creed values on-chain as the foundation.
 */
contract BayekProtocol {
    address public masterFounder;
    string public creedCore;
    bool public creedLocked;

    event CreedFounded(string creed, uint256 timestamp);
    event CreedLocked();

    modifier onlyFounder() {
        require(msg.sender == masterFounder, "Unauthorized: Only the Master Founder can set the Creed.");
        _;
    }

    constructor(string memory _initialCreed) {
        masterFounder = msg.sender;
        creedCore = _initialCreed;
        creedLocked = false;
    }

    function foundCreed(string calldata _newCreed) external onlyFounder {
        require(!creedLocked, "Creed is already locked permanently.");
        creedCore = _newCreed;
        creedLocked = true;
        emit CreedFounded(_newCreed, block.timestamp);
        emit CreedLocked();
    }
}
