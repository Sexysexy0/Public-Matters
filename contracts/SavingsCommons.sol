// contracts/SavingsCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SavingsCommons
 * @notice Logs communal savings pools and equity in financial resilience.
 */
contract SavingsCommons {
    address public admin;

    struct Pool {
        string name;        // "CommunityFund", "EmergencyPool"
        uint256 balance;
        string status;      // "Active", "Dormant"
        uint256 timestamp;
    }

    Pool[] public pools;

    event PoolLogged(string name, uint256 balance, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPool(string calldata name, uint256 balance, string calldata status) external onlyAdmin {
        pools.push(Pool(name, balance, status, block.timestamp));
        emit PoolLogged(name, balance, status, block.timestamp);
    }

    function totalPools() external view returns (uint256) { return pools.length; }

    function getPool(uint256 id) external view returns (Pool memory) {
        require(id < pools.length, "Invalid id");
        return pools[id];
    }
}
