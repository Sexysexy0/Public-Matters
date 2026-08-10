// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AltairProtocol
 * @dev Discipline archetype: rebuilds the Brotherhood, enforces strict rules.
 */
contract AltairProtocol {
    address public master;
    bool public locked;

    event DisciplineInvoked(address indexed caller);
    event Locked(address indexed caller);

    modifier onlyMaster() {
        require(msg.sender == master, "Only master");
        _;
    }

    constructor() {
        master = msg.sender;
        locked = false;
    }

    function discipline() external onlyMaster {
        require(!locked, "Already locked");
        emit DisciplineInvoked(msg.sender);
        locked = true;
        emit Locked(msg.sender);
    }
}
