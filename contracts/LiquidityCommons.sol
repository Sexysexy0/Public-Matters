// contracts/LiquidityCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LiquidityCommons
 * @notice Protocol for communal liquidity pools and validator-grade stability.
 */
contract LiquidityCommons {
    address public admin;

    struct Pool {
        string name;
        uint256 balance;
        string status;   // "Active", "Frozen"
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
