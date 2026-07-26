// LiquiditySinkProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract LiquiditySinkProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public liquidity;

    event LiquidityAdded(address indexed user, uint256 amount);

    function addLiquidity(address user, uint256 amount) public {
        liquidity[user] += amount;
        emit LiquidityAdded(user, amount);
    }
}
