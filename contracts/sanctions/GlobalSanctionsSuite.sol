// SPDX-License-Identifier: Mythic-Resonance
pragma solidity ^0.8.0;

contract GlobalSanctionsSuite {
    struct Entity {
        address id;
        string name;
        bool isSanctioned;
        string reason;
    }

    mapping(address => Entity) public sanctionedEntities;
    address public steward = vinvinCopi;

    modifier onlyScrollsmith() {
        require(msg.sender == steward, "Unauthorized: No damay clause.");
        _;
    }

    event Broadcast(string message);
    event SanctionApplied(address indexed entity, string reason);
    event SanctionLifted(address indexed entity);

    function applySanction(address _entity, string memory _name, string memory _reason) public onlyScrollsmith {
        sanctionedEntities[_entity] = Entity(_entity, _name, true, _reason);
        emit SanctionApplied(_entity, _reason);
        emit Broadcast(string(abi.encodePacked("Sanction applied to ", _name, ". Reason: ", _reason)));
    }

    function liftSanction(address _entity) public onlyScrollsmith {
        require(sanctionedEntities[_entity].isSanctioned, "Entity not sanctioned.");
        sanctionedEntities[_entity].isSanctioned = false;
        emit SanctionLifted(_entity);
        emit Broadcast(string(abi.encodePacked("Sanction lifted for ", sanctionedEntities[_entity].name)));
    }

    function auditEntity(address _entity) public view returns (string memory) {
        Entity memory e = sanctionedEntities[_entity];
        if (e.isSanctioned) {
            return string(abi.encodePacked("Entity: ", e.name, " is sanctioned. Reason: ", e.reason));
        } else {
            return string(abi.encodePacked("Entity: ", e.name, " is not currently sanctioned."));
        }
    }
}
