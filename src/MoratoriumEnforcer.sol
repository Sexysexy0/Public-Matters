// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MoratoriumEnforcer {
    bool public isMoratoriumActive = true;
    address public steward;

    event MoratoriumToggled(bool active);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function toggleMoratorium(bool _active) external onlySteward {
        isMoratoriumActive = _active;
        emit MoratoriumToggled(_active);
    }

    function verifyAndExecute(
        bytes32 /* projectId */
    )
        external
        view
    {
        require(!isMoratoriumActive, "Moratorium active: High-energy data center project blocked");
    }
}
