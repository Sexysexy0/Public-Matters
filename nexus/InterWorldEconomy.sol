// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InterWorldEconomy {
    mapping(address => uint256) public nexusBalance;

    // Bridge logic to reward players for exploring
    function rewardExplorer(address _player, uint256 _amount) external {
        nexusBalance[_player] += _amount;
    }

    function buyMarketItem(address _player, uint256 _cost) external returns (bool) {
        require(nexusBalance[_player] >= _cost, "INSUFFICIENT CREDITS");
        nexusBalance[_player] -= _cost;
        return true;
    }
}
