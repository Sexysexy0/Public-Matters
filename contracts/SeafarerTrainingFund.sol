pragma solidity ^0.8.0;

contract SeafarerTrainingFund {
    mapping(address => uint256) public grants;

    function releaseGrant(address academy, uint256 score) public {
        require(score < 80, "Academy meets standards");
        grants[academy] += 1000000; // Fund allocation for training upgrade
    }
}
