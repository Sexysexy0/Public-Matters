// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract ExecutivePipeline {
    struct Role {
        address holder;
        uint256 startBlock;
        uint256 tenureLimit;
    }

    mapping(bytes32 => Role) public roles;

    event RoleAssigned(bytes32 indexed roleId, address holder, uint256 tenureLimit);
    event RoleExpired(bytes32 indexed roleId, address holder);

    function assignRole(bytes32 roleId, address holder, uint256 tenureLimit) external {
        roles[roleId] = Role(holder, block.number, tenureLimit);
        emit RoleAssigned(roleId, holder, tenureLimit);
    }

    function checkExpiry(bytes32 roleId) external {
        Role memory r = roles[roleId];
        if (block.number > r.startBlock + r.tenureLimit) {
            emit RoleExpired(roleId, r.holder);
        }
    }
}
