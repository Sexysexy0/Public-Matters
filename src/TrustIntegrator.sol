// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrustIndex {
    function reportTrustAction(uint256 _customWeight) external;
    function reportTrustSetback(uint256 _customWeight) external;
}

/**
 * @title TrustIntegrator
 * @dev A simple bridge that allows other kingdom contracts to update the TrustIndex.
 */
contract TrustIntegrator {
    address public immutable steward;
    ITrustIndex public trustIndex;

    event TrustUpdated(string actionType, uint256 weight);

    modifier onlySteward() {
        require(msg.sender == steward, "Only the steward");
        _;
    }

    constructor(address _trustIndex) {
        steward = msg.sender;
        trustIndex = ITrustIndex(_trustIndex);
    }

    // Allow authorized contracts (like Lending or Broadcast) to log positive actions
    function logPositiveAction(uint256 _weight) external {
        // In production, you'd add a whitelist check here for the msg.sender.
        // For now, we'll let anyone call it, but restrict weight to 10.
        uint256 actualWeight = _weight > 0 && _weight <= 10 ? _weight : 10;
        trustIndex.reportTrustAction(actualWeight);
        emit TrustUpdated("Positive", actualWeight);
    }

    // Allow authorized contracts to log setbacks
    function logSetback(uint256 _weight) external {
        uint256 actualWeight = _weight > 0 && _weight <= 20 ? _weight : 20;
        trustIndex.reportTrustSetback(actualWeight);
        emit TrustUpdated("Setback", actualWeight);
    }

    // Change the TrustIndex address if needed (you only)
    function setTrustIndex(address _newTrustIndex) external onlySteward {
        trustIndex = ITrustIndex(_newTrustIndex);
    }
}
