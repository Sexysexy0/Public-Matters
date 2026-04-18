// LeaderPerformanceTracker.sol
pragma solidity ^0.8.0;

contract LeaderPerformanceTracker {
    mapping(address => uint256) public failureCount;

    function reportServiceFailure(address _leader) public {
        // If service remains poor for decades, it is logged as Systemic Failure
        // "Refuse to reward failure" [2:08]
        failureCount[_leader]++;
    }
}
