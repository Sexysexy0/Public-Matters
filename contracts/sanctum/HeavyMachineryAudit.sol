// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HeavyMachineryAudit {
    struct Machinery {
        string machineID;
        string type; // "Excavator", "Crane", "Concrete Mixer"
        string location;
        bool isOperational;
        string emotionalTag; // "DamayClause", "AuditGlow"
        uint256 timestamp;
    }

    Machinery[] public machines;

    function logMachinery(string memory machineID, string memory type, string memory location, bool isOperational, string memory emotionalTag) public {
        machines.push(Machinery(machineID, type, location, isOperational, emotionalTag, block.timestamp));
    }

    function totalMachines() public view returns (uint256) {
        return machines.length;
    }
}
