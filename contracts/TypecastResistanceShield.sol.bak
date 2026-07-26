// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TypecastResistanceShield {
    struct Role {
        address actor;
        string project;
        string roleType;
        uint256 timestamp;
        bool safeguarded;
    }

    Role[] public roles;

    event RoleLogged(address indexed actor, string project, string roleType);
    event RoleSafeguarded(uint256 indexed id, address verifier);

    function logRole(string memory _project, string memory _roleType) public {
        roles.push(Role(msg.sender, _project, _roleType, block.timestamp, false));
        emit RoleLogged(msg.sender, _project, _roleType);
    }

    function safeguardRole(uint256 _id) public {
        require(_id < roles.length, "Invalid ID");
        roles[_id].safeguarded = true;
        emit RoleSafeguarded(_id, msg.sender);
    }

    function getRole(uint256 _id) public view returns (Role memory) {
        require(_id < roles.length, "Invalid ID");
        return roles[_id];
    }

    function totalRoles() public view returns (uint256) {
        return roles.length;
    }
}
