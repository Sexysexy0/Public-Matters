// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IStablecoin {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract StablecoinSettlementRail {
    address public stablecoinAddress;

    event SettlementExecuted(address indexed sender, address indexed receiver, uint256 amount, string fiatTag);

    constructor(address _stablecoinAddress) {
        stablecoinAddress = _stablecoinAddress;
    }

    function settle(address receiver, uint256 amount, string memory fiatTag) external {
        require(IStablecoin(stablecoinAddress).transfer(receiver, amount), "Transfer failed");
        emit SettlementExecuted(msg.sender, receiver, amount, fiatTag);
    }
}
