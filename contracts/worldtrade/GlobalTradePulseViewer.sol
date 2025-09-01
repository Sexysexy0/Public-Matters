// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./TradePulseRegistry.sol";

contract GlobalTradePulseViewer {
    TradePulseRegistry public registry;

    constructor(address _registryAddress) {
        registry = TradePulseRegistry(_registryAddress);
    }

    struct PulseView {
        string country;
        string assetType;
        uint256 surplus;
        uint256 demand;
        string timestamp;
        string emotionalAPRTag;
    }

    function getAllPulses() public view returns (PulseView[] memory) {
        uint256 count = registry.getPulseCount();
        PulseView[] memory views = new PulseView[](count);

        for (uint256 i = 0; i < count; i++) {
            (
                string memory country,
                string memory assetType,
                uint256 surplus,
                uint256 demand,
                string memory timestamp,
                string memory emotionalAPRTag
            ) = registry.getPulseByIndex(i);

            views[i] = PulseView({
                country: country,
                assetType: assetType,
                surplus: surplus,
                demand: demand,
                timestamp: timestamp,
                emotionalAPRTag: emotionalAPRTag
            });
        }

        return views;
    }
}
