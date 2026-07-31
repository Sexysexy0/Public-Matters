// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SammaCodex {
    bytes32 public constant OVERSEER_ROLE = keccak256("OVERSEER_ROLE");

    struct Principle {
        uint256 id;
        string title;
        string description;
        bool active;
    }

    uint256 public principleCount;
    mapping(uint256 => Principle) public principles;
    mapping(address => mapping(bytes32 => bool)) private roles;

    event PrincipleDeclared(uint256 indexed id, string title, string description);
    event PrincipleRevoked(uint256 indexed id, string reason);

    modifier onlyRole(bytes32 role) {
        require(roles[msg.sender][role] || msg.sender == owner, "Not authorized");
        _;
    }

    address public owner;

    constructor(address admin) {
        owner = admin != address(0) ? admin : msg.sender;
        roles[owner][OVERSEER_ROLE] = true;
    }

    function declarePrinciple(string calldata title, string calldata description) external {
        principleCount++;
        principles[principleCount] = Principle({
            id: principleCount,
            title: title,
            description: description,
            active: true
        });
        emit PrincipleDeclared(principleCount, title, description);
    }

    function revokePrinciple(uint256 id, string calldata reason) external onlyRole(OVERSEER_ROLE) {
        require(id > 0 && id <= principleCount, "Principle does not exist");
        require(principles[id].active, "Principle not active");

        principles[id].active = false;
        emit PrincipleRevoked(id, reason);
    }

    function isActive(uint256 id) external view returns (bool) {
        if (id == 0 || id > principleCount) return false;
        return principles[id].active;
    }
}
