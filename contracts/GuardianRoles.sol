// contracts/GuardianRoles.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GuardianRoles
 * @notice Assign granular guardianship roles per LGU/intersection.
 */
contract GuardianRoles {
    address public owner;
    mapping(address => string) public roles;

    event RoleAssigned(address indexed guardian, string role);
    event RoleRevoked(address indexed guardian);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function assignRole(address guardian, string calldata role) external onlyOwner {
        roles[guardian] = role;
        emit RoleAssigned(guardian, role);
    }

    function revokeRole(address guardian) external onlyOwner {
        delete roles[guardian];
        emit RoleRevoked(guardian);
    }

    function getRole(address guardian) external view returns (string memory) {
        return roles[guardian];
    }
}
