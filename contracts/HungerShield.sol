// contracts/HungerShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HungerShield
 * @notice Logs hunger relief measures and communal resilience in food systems.
 */
contract HungerShield {
    address public admin;

    struct Relief {
        string program;     // "FoodBank", "SchoolMeals"
        uint256 beneficiaries;
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Relief[] public reliefs;

    event ReliefLogged(string program, uint256 beneficiaries, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRelief(string calldata program, uint256 beneficiaries, string calldata status) external onlyAdmin {
        reliefs.push(Relief(program, beneficiaries, status, block.timestamp));
        emit ReliefLogged(program, beneficiaries, status, block.timestamp);
    }

    function totalReliefs() external view returns (uint256) { return reliefs.length; }

    function getRelief(uint256 id) external view returns (Relief memory) {
        require(id < reliefs.length, "Invalid id");
        return reliefs[id];
    }
}
