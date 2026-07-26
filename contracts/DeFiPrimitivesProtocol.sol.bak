// DeFiPrimitivesProtocol.sol
pragma solidity ^0.8.0;

contract DeFiPrimitivesProtocol {
    mapping(address => uint256) public stablecoinCollateral;

    event MintStablecoin(address indexed user, uint256 amount);

    function mintStablecoin(address user, uint256 amount) public {
        stablecoinCollateral[user] += amount;
        emit MintStablecoin(user, amount);
    }
}
