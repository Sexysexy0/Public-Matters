// SPDX-License-Identifier: YieldSanctum
pragma solidity ^0.8.19;

contract YieldRotationAuditRouter {
    struct YieldStrategy {
        address asset;
        string protocol; // e.g., "Aave", "Curve", "Beefy", "Yearn"
        uint256 currentAPR;
        uint256 historicalVolatility;
        bool rotationRecommended;
        string stewardNote;
    }

    mapping(address => YieldStrategy) public strategies;

    event StrategyTagged(address asset, string protocol);
    event RotationTriggered(address asset);

    function tagStrategy(address asset, string memory protocol, uint256 currentAPR, uint256 historicalVolatility, bool rotationRecommended, string memory stewardNote) public {
        strategies[asset] = YieldStrategy(asset, protocol, currentAPR, historicalVolatility, rotationRecommended, stewardNote);
        emit StrategyTagged(asset, protocol);
    }

    function triggerRotation(address asset) public {
        strategies[asset].rotationRecommended = true;
        emit RotationTriggered(asset);
    }

    function getStrategyStatus(address asset) public view returns (YieldStrategy memory) {
        return strategies[asset];
    }
}
