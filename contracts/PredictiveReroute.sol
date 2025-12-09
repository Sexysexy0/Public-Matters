// contracts/PredictiveReroute.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PredictiveReroute {
    struct Simulation {
        string route;
        uint256 predictedLoad;
        string recommendation;
    }

    Simulation[] public sims;
    address public owner;

    event SimulationLogged(string route, uint256 predictedLoad, string recommendation);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logSimulation(string calldata route, uint256 load, string calldata recommendation) external onlyOwner {
        sims.push(Simulation(route, load, recommendation));
        emit SimulationLogged(route, load, recommendation);
    }

    function totalSimulations() external view returns (uint256) {
        return sims.length;
    }
}
