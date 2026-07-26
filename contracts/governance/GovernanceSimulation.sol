// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GovernanceSimulation {
    event SimulationRun(string action, bytes data);

    function simulate(
        string memory action,
        bytes memory data
    ) external {
        emit SimulationRun(action, data);
    }
}
