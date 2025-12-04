// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToAirSafetySystemsAuditLedger {
    string public batchID = "1321.9.246";
    string public steward = "Vinvin";

    address public admin;

    struct SafetySystem {
        string system;     // autopilot, collision avoidance, weather radar
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    SafetySystem[] public systems;

    event SafetySystemLogged(string system, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logSystem(string memory system, string memory status) public onlyAdmin {
        systems.push(SafetySystem(system, status, block.timestamp));
        emit SafetySystemLogged(system, status);
    }

    function getSystem(uint256 index) public view returns (string memory system, string memory status, uint256 timestamp) {
        SafetySystem memory s = systems[index];
        return (s.system, s.status, s.timestamp);
    }
}
