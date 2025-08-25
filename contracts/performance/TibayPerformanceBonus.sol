pragma solidity ^0.8.19;

contract TibayPerformanceBonus {
    address public contractor;
    uint256 public baseReward;
    uint8 public durabilityScore; // 0–100
    uint8 public aestheticScore;  // 0–100
    uint8 public civicFeedback;   // 0–100

    constructor(address _contractor, uint256 _baseReward, uint8 _durability, uint8 _aesthetic, uint8 _feedback) {
        contractor = _contractor;
        baseReward = _baseReward;
        durabilityScore = _durability;
        aestheticScore = _aesthetic;
        civicFeedback = _feedback;
    }

    function calculateBonus() public view returns (uint256) {
        uint256 totalScore = durabilityScore + aestheticScore + civicFeedback;
        return (baseReward * totalScore) / 300; // Weighted bonus
    }

    function totalPayout() external view returns (uint256) {
        return baseReward + calculateBonus();
    }
}
