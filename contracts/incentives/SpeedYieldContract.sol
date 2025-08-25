pragma solidity ^0.8.19;

contract SpeedYieldContract {
    address public contractor;
    uint256 public dueDate;
    uint256 public completionDate;
    uint256 public baseReward;
    uint256 public speedBonus;

    constructor(address _contractor, uint256 _dueDate, uint256 _completionDate, uint256 _baseReward) {
        contractor = _contractor;
        dueDate = _dueDate;
        completionDate = _completionDate;
        baseReward = _baseReward;
        calculateBonus();
    }

    function calculateBonus() internal {
        if (completionDate < dueDate) {
            uint256 daysEarly = (dueDate - completionDate) / 1 days;
            uint256 cappedDays = daysEarly > 30 ? 30 : daysEarly;
            speedBonus = cappedDays * 10000 ether; // ₱10,000/day
        }
    }

    function totalPayout() external view returns (uint256) {
        return baseReward + speedBonus;
    }
}
