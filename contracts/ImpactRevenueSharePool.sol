// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OperatorPrivilegesV2} from "../src/OperatorPrivilegesV2.sol";

contract ImpactRevenueSharePool {
    OperatorPrivilegesV2 public immutable operatorPrivileges;

    struct Share {
        uint256 contributions;
        uint256 verifiedOutcomes;
        uint256 weight; // 0-10000 basis points
        bool claimed;
    }

    mapping(address => Share) public shares;
    uint256 public totalPool;
    uint256 public totalWeight;

    event ContributionRecorded(address indexed contributor, uint256 amount);
    event OutcomeVerified(address indexed contributor, uint256 count);
    event WeightSet(address indexed contributor, uint256 weight);
    event RevenueDeposited(address indexed from, uint256 amount);
    event Claimed(address indexed contributor, uint256 amount);

    modifier onlyOperator() {
        require(operatorPrivileges.isOperator(msg.sender), "Not operator");
        _;
    }

    constructor(address _operatorPrivileges) {
        operatorPrivileges = OperatorPrivilegesV2(_operatorPrivileges);
    }

    function recordContribution(address contributor, uint256 amount) external onlyOperator {
        shares[contributor].contributions += amount;
        emit ContributionRecorded(contributor, amount);
    }

    function verifyOutcome(address contributor) external onlyOperator {
        shares[contributor].verifiedOutcomes += 1;
        emit OutcomeVerified(contributor, shares[contributor].verifiedOutcomes);
    }

    function setWeight(address contributor, uint256 weight) external onlyOperator {
        require(weight <= 10000, "Weight too high");
        uint256 oldWeight = shares[contributor].weight;
        totalWeight = totalWeight - oldWeight + weight;
        shares[contributor].weight = weight;
        emit WeightSet(contributor, weight);
    }

    function depositRevenue() external payable {
        totalPool += msg.value;
        emit RevenueDeposited(msg.sender, msg.value);
    }

    function claimShare() external {
        Share storage s = shares[msg.sender];
        require(!s.claimed, "Already claimed");
        require(s.weight > 0, "No weight");
        uint256 payout = (totalPool * s.weight) / totalWeight;
        s.claimed = true;
        payable(msg.sender).transfer(payout);
        emit Claimed(msg.sender, payout);
    }
}
