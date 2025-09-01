// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ConflictOfInterestShield {
    struct Entity {
        string name;
        string role; // e.g. "Prime Contractor", "Subcontractor", "JV Partner"
        string affiliation; // e.g. "Same Owner", "Relative", "Shell Entity"
        bool declaredConflict;
        string emotionalTag; // e.g. "DamayClause", "AuditGlow", "GhostPing"
        uint256 timestamp;
    }

    Entity[] public entities;

    event ConflictLogged(string name, string role, string affiliation, bool declaredConflict, string emotionalTag);

    function logEntity(
        string memory _name,
        string memory _role,
        string memory _affiliation,
        bool _declaredConflict,
        string memory _emotionalTag
    ) public {
        entities.push(Entity(_name, _role, _affiliation, _declaredConflict, _emotionalTag, block.timestamp));
        emit ConflictLogged(_name, _role, _affiliation, _declaredConflict, _emotionalTag);
    }

    function getEntity(uint256 index) public view returns (Entity memory) {
        return entities[index];
    }

    function totalEntities() public view returns (uint256) {
        return entities.length;
    }
}
