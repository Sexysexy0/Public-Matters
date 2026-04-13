// UniversalProductivityIncentive.sol
pragma solidity ^0.8.0;

contract UniversalProductivityIncentive {
    mapping(address => uint256) public productivityScore;

    function rewardEffort(address _worker, uint256 _score) public {
        // Logic: Direct value transfer. 
        // Effort = Credits. No inflation, no bureaucracy.
        productivityScore[_worker] += _score;
    }
}
