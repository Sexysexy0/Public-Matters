// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SupplyChainStressSignal
/// @dev Simulates stress events in supply chain and logs mitigation strategies

contract SupplyChainStressSignal {
    struct Disruption {
        string region;
        string cause;
        uint256 severity; // 1–100 scale
        uint256 timestamp;
    }

    Disruption[] public disruptions;
    mapping(string => string) public mitigationStrategies;

    event DisruptionLogged(string region, string cause, uint256 severity);
    event StrategyUpdated(string region, string strategy);

    function logDisruption(string memory region, string memory cause, uint256 severity) external {
        disruptions.push(Disruption(region, cause, severity, block.timestamp));
        emit DisruptionLogged(region, cause, severity);
    }

    function updateStrategy(string memory region, string memory strategy) external {
        mitigationStrategies[region] = strategy;
        emit StrategyUpdated(region, strategy);
    }

    function getLatestDisruption() external view returns (Disruption memory) {
        require(disruptions.length > 0, "No disruptions logged");
        return disruptions[disruptions.length - 1];
    }
}
