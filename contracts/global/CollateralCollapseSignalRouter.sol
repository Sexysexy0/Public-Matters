// SPDX-License-Identifier: CollapseSanctum
pragma solidity ^0.8.19;

contract CollateralCollapseSignalRouter {
    struct CollapseSignal {
        address asset;
        uint256 collateralValue;
        uint256 debtOutstanding;
        uint256 systemCR; // Collateralization Ratio
        bool emergencyTriggered;
        string stewardNote;
    }

    mapping(address => CollapseSignal) public collapseSignals;

    event CollapseTagged(address asset, uint256 systemCR);
    event EmergencyTriggered(address asset);

    function tagSignal(address asset, uint256 collateralValue, uint256 debtOutstanding, uint256 systemCR, string memory stewardNote) public {
        collapseSignals[asset] = CollapseSignal(asset, collateralValue, debtOutstanding, systemCR, false, stewardNote);
        emit CollapseTagged(asset, systemCR);
    }

    function triggerEmergency(address asset) public {
        require(collapseSignals[asset].systemCR <= 115, "System CR not critical yet");
        collapseSignals[asset].emergencyTriggered = true;
        emit EmergencyTriggered(asset);
    }

    function getSignalStatus(address asset) public view returns (CollapseSignal memory) {
        return collapseSignals[asset];
    }
}
