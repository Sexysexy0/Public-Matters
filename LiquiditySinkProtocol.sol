// LiquiditySinkProtocol.sol
pragma solidity ^0.8.0;

contract LiquiditySinkProtocol {
    mapping(address => uint256) public liquidity;

    event LiquidityAdded(address indexed user, uint256 amount);

    function addLiquidity(address user, uint256 amount) public {
        liquidity[user] += amount;
        emit LiquidityAdded(user, amount);
    }
}
