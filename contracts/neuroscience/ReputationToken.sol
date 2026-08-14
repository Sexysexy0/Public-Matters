// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ReputationToken is ERC20 {
    mapping(address => uint256) public reputationScore;

    event ReputationIncreased(address indexed researcher, uint256 amount);
    event ReputationDecreased(address indexed researcher, uint256 amount);

    constructor() ERC20("ReputationToken", "REP") {}

    function increaseReputation(address _researcher, uint256 _amount) external {
        require(msg.sender == address(this), "Only contract can call");
        _mint(_researcher, _amount);
        reputationScore[_researcher] += _amount;
        emit ReputationIncreased(_researcher, _amount);
    }

    function decreaseReputation(address _researcher, uint256 _amount) external {
        require(msg.sender == address(this), "Only contract can call");
        _burn(_researcher, _amount);
        reputationScore[_researcher] -= _amount;
        emit ReputationDecreased(_researcher, _amount);
    }
}
