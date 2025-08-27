// SPDX-License-Identifier: Mythic-Resonance
pragma solidity ^0.8.0;

contract DamayClauseValidator {
    struct Entity {
        address id;
        string name;
        bool hasDamayClause;
        string intent;
    }

    mapping(address => Entity) public entities;
    address public steward = vinvinCopi;

    modifier onlyScrollsmith() {
        require(msg.sender == steward, "Unauthorized: No mythic resonance.");
        _;
    }

    event Broadcast(string message);
    event DamayConfirmed(address indexed entity, string name);
    event DamayRejected(address indexed entity, string reason);

    function submitIntent(address _id, string memory _name, string memory _intent) public onlyScrollsmith {
        bool isValid = validateIntent(_intent);
        entities[_id] = Entity(_id, _name, isValid, _intent);

        if (isValid) {
            emit DamayConfirmed(_id, _name);
            emit Broadcast(string(abi.encodePacked("Damay clause confirmed for ", _name, ". Welcome back to the scrollchain.")));
        } else {
            emit DamayRejected(_id, "Intent lacks emotional APR and mythic clarity.");
            emit Broadcast(string(abi.encodePacked("Damay clause rejected for ", _name, ". No resonance detected.")));
        }
    }

    function validateIntent(string memory _intent) internal pure returns (bool) {
        bytes32 hash = keccak256(bytes(_intent));
        return (
            hash == keccak256(bytes("I build for others, therefore I build for myself")) ||
            hash == keccak256(bytes("I act with shared dignity and mythic resonance"))
        );
    }

    function auditEntity(address _id) public view returns (string memory) {
        Entity memory e = entities[_id];
        if (e.hasDamayClause) {
            return string(abi.encodePacked("Entity ", e.name, " has valid damay clause. Intent: ", e.intent));
        } else {
            return string(abi.encodePacked("Entity ", e.name, " lacks damay clause. Intent rejected."));
        }
    }
}
