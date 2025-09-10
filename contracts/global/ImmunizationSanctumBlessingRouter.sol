// SPDX-License-Identifier: ImmunizationSanctumBlessing-License
pragma solidity ^0.8.0;

contract ImmunizationSanctumBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string region;
        string vaccineType;
        bool publicTrustConfirmed;
        bool restorationActivated;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event ImmunizationBlessingRouted(string region, string vaccineType, bool publicTrustConfirmed, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory region, string memory vaccineType, bool publicTrustConfirmed, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(region, vaccineType, publicTrustConfirmed, restorationActivated, block.timestamp));
        emit ImmunizationBlessingRouted(region, vaccineType, publicTrustConfirmed, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.publicTrustConfirmed, s.restorationActivated, s.timestamp);
    }
}
