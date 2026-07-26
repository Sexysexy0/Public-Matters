pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MaritimeStandardsUpgrade is Ownable {

    constructor() Ownable(msg.sender) {}

    mapping(address => uint256) public grants;

    function releaseGrant(address academy, uint256 complianceScore) public {
        if (complianceScore < 80) {
            grants[academy] += 500000; // Fund allocation for training upgrade
        }
    }
}
