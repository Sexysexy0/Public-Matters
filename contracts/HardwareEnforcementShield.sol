// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HardwareEnforcementShield {
    struct Enforcement {
        address offender;
        string franchise;
        string action;
        uint256 timestamp;
        bool safeguarded;
    }

    Enforcement[] public enforcements;

    event EnforcementLogged(address indexed offender, string franchise, string action);
    event EnforcementSafeguarded(uint256 indexed id, address verifier);

    function logEnforcement(string memory _franchise, string memory _action) public {
        enforcements.push(Enforcement(msg.sender, _franchise, _action, block.timestamp, false));
        emit EnforcementLogged(msg.sender, _franchise, _action);
    }

    function safeguardEnforcement(uint256 _id) public {
        require(_id < enforcements.length, "Invalid ID");
        enforcements[_id].safeguarded = true;
        emit EnforcementSafeguarded(_id, msg.sender);
    }

    function getEnforcement(uint256 _id) public view returns (Enforcement memory) {
        require(_id < enforcements.length, "Invalid ID");
        return enforcements[_id];
    }

    function totalEnforcements() public view returns (uint256) {
        return enforcements.length;
    }
}
