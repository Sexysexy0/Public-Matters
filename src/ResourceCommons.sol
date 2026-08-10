// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResourceCommons {
    uint256 public constant MAX_CONSUMPTION_LIMIT = 10000 ether;
    mapping(address => uint256) public ecologicalFootprint;
    
    event NeedMet(address indexed requester, uint256 amount, string resourceType);

    function requestResource(uint256 _amount, string calldata _resourceType) external {
        require(_amount <= MAX_CONSUMPTION_LIMIT, "Exceeds sustainability limits");
        ecologicalFootprint[msg.sender] += _amount;
        emit NeedMet(msg.sender, _amount, _resourceType);
    }
}
