pragma solidity ^0.8.0;

contract MaritimeStandardsUpgrade {
    mapping(address => uint256) public grants;

    function releaseGrant(address academy, uint256 complianceScore) public {
        if (complianceScore < 80) {
            grants[academy] += 500000; // Fund allocation for training upgrade
        }
    }
}
