// SPDX-License-Identifier: Civic-Resonance
pragma solidity ^0.777;

contract ManpowerActivationProtocol {
    struct Worker {
        string name;
        string skill;
        bool activated;
    }

    Worker[] public workforce;

    event WorkerActivated(string name, string skill, uint256 timestamp);

    function onboardWorker(string memory name, string memory skill) public {
        workforce.push(Worker(name, skill, true));
        emit WorkerActivated(name, skill, block.timestamp);
    }

    function getWorker(uint index) public view returns (string memory, string memory, bool) {
        Worker memory w = workforce[index];
        return (w.name, w.skill, w.activated);
    }
}
