// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TrustIndex
 * @dev A dynamic on-chain metric representing the system's health and usage.
 * Scored by community actions (loans, claims, broadcasts).
 */
contract TrustIndex {
    address public immutable steward;
    uint256 public currentIndex;
    uint256 public baseActionWeight; // Default weight for a generic trust action

    event TrustIndexUpdated(uint256 newIndex, string reason);
    event BaseWeightUpdated(uint256 newWeight);

    modifier onlySteward() {
        require(msg.sender == steward, "Only the steward");
        _;
    }

    constructor(uint256 _initialIndex, uint256 _baseWeight) {
        steward = msg.sender;
        currentIndex = _initialIndex;
        baseActionWeight = _baseWeight;
    }

    // Report a positive trust action (e.g., a loan repaid or a claim processed)
    function reportTrustAction(uint256 _customWeight) external {
        uint256 weight = _customWeight > 0 ? _customWeight : baseActionWeight;
        currentIndex += weight;
        emit TrustIndexUpdated(currentIndex, "Positive action recorded");
    }

    // Report a negative trust event (e.g., a failed repayment or system alert)
    function reportTrustSetback(uint256 _customWeight) external {
        uint256 weight = _customWeight > 0 ? _customWeight : baseActionWeight;
        // Prevent underflow
        if (currentIndex >= weight) {
            currentIndex -= weight;
        } else {
            currentIndex = 0;
        }
        emit TrustIndexUpdated(currentIndex, "Setback recorded");
    }

    // Update the base weight (how much a standard action is worth)
    function setBaseWeight(uint256 _newWeight) external onlySteward {
        baseActionWeight = _newWeight;
        emit BaseWeightUpdated(_newWeight);
    }

    function getTrustIndex() external view returns (uint256) {
        return currentIndex;
    }
}
