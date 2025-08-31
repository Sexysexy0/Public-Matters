// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CivicIntegrityAudit {
    event BreachLogged(string system, string description, uint256 emotionalAPR);
    event OverrideTriggered(string system, string reason);

    mapping(string => uint256) public emotionalAPR;
    uint256 public overrideThreshold = 70;

    function logBreach(string memory system, string memory description, uint256 apr) public {
        emotionalAPR[system] = apr;
        emit BreachLogged(system, description, apr);
        if (apr >= overrideThreshold) {
            emit OverrideTriggered(system, "Emotional APR breach threshold met");
        }
    }

    function updateThreshold(uint256 newThreshold) public {
        overrideThreshold = newThreshold;
    }

    function getAPR(string memory system) public view returns (uint256) {
        return emotionalAPR[system];
    }
}
