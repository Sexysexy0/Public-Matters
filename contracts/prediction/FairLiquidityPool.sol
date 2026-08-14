// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FairLiquidityPool {
    struct Pool {
        uint256 totalLiquidity;
        uint256 maxPerUser;
        mapping(address => uint256) userLiquidity;
        address[] participants;
    }

    mapping(bytes32 => Pool) public pools;
    mapping(address => mapping(bytes32 => uint256)) public userPoolLiquidity;

    event LiquidityAdded(address indexed user, bytes32 indexed poolId, uint256 amount);
    event LiquidityRemoved(address indexed user, bytes32 indexed poolId, uint256 amount);

    function addLiquidity(bytes32 _poolId, uint256 _amount) external {
        Pool storage pool = pools[_poolId];
        if (pool.maxPerUser == 0) {
            pool.maxPerUser = 100 ether;
        }
        require(pool.userLiquidity[msg.sender] + _amount <= pool.maxPerUser, "Exceeds per-user limit");
        require(pool.totalLiquidity + _amount <= 1e6 * 1e18, "Pool cap reached");

        if (pool.userLiquidity[msg.sender] == 0) {
            pool.participants.push(msg.sender);
        }
        pool.userLiquidity[msg.sender] += _amount;
        pool.totalLiquidity += _amount;
        userPoolLiquidity[msg.sender][_poolId] += _amount;

        emit LiquidityAdded(msg.sender, _poolId, _amount);
    }

    function removeLiquidity(bytes32 _poolId, uint256 _amount) external {
        Pool storage pool = pools[_poolId];
        require(pool.userLiquidity[msg.sender] >= _amount, "Insufficient liquidity");

        pool.userLiquidity[msg.sender] -= _amount;
        pool.totalLiquidity -= _amount;
        userPoolLiquidity[msg.sender][_poolId] -= _amount;

        emit LiquidityRemoved(msg.sender, _poolId, _amount);
    }

    function getPoolParticipants(bytes32 _poolId) external view returns (address[] memory) {
        return pools[_poolId].participants;
    }
}
