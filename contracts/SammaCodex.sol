// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract SammaCodex is AccessControl {
    bytes32 public constant OVERSEER_ROLE = keccak256("OVERSEER_ROLE");

    struct Principle {
        uint256 id;
        string name;
        string description;
        uint256 timestamp;
        bool active;
    }

    uint256 public principleCount;
    mapping(uint256 => Principle) public principles;

    event PrincipleDeclared(uint256 id, string name, string description);
    event PrincipleRevoked(uint256 id, string reason);

    constructor(address overseer) {
        _grantRole(DEFAULT_ADMIN_ROLE, overseer);
        _grantRole(OVERSEER_ROLE, overseer);
    }

    // Declare a new principle (e.g. "Academic Freedom", "Least Privilege")
    function declarePrinciple(string calldata name, string calldata description)
        external
        onlyRole(OVERSEER_ROLE)
    {
        principleCount++;
        principles[principleCount] = Principle({
            id: principleCount,
            name: name,
            description: description,
            timestamp: block.timestamp,
            active: true
        });
        emit PrincipleDeclared(principleCount, name, description);
    }

    // Revoke principle if violated or outdated
    function revokePrinciple(uint256 id, string calldata reason)
        external
        onlyRole(OVERSEER_ROLE)
    {
        require(principles[id].active, "Principle not active");
        principles[id].active = false;
        emit PrincipleRevoked(id, reason);
    }

    // Check if principle is active
    function isActive(uint256 id) external view returns (bool) {
        return principles[id].active;
    }
}
