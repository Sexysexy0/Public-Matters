// SPDX-License-Identifier: MIT
// Contract Name: DailyRewardCovenant
// Purpose: Encode systemic safeguards for daily login rewards, random prize distribution, and mega pack milestones
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract DailyRewardCovenant {
    address public chiefOperator;

    struct RewardRecord {
        string principle;   // e.g. Daily login, Random prize, Mega pack milestone
        string mechanism;   // e.g. Coupon drops, Item pools, 7-day streak packs
        string sector;      // e.g. Gaming, Marketplace, Digital ecosystem
        string outcome;     // e.g. Engagement boosted, Rewards distributed, Fairness upheld
        uint256 timestamp;
    }

    RewardRecord[] public records;

    event RewardLogged(string principle, string mechanism, string sector, string outcome, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function logReward(
        string memory principle,
        string memory mechanism,
        string memory sector,
        string memory outcome
    ) public onlyChief {
        records.push(RewardRecord(principle, mechanism, sector, outcome, block.timestamp));
        emit RewardLogged(principle, mechanism, sector, outcome, block.timestamp);
    }

    function getReward(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < records.length, "Invalid reward index");
        RewardRecord memory rr = records[index];
        return (rr.principle, rr.mechanism, rr.sector, rr.outcome, rr.timestamp);
    }
}
