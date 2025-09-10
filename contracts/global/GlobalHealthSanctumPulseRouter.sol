// SPDX-License-Identifier: GlobalHealthSanctumPulse-License
pragma solidity ^0.8.0;

contract GlobalHealthSanctumPulseRouter {
    address public steward;

    struct PulseSignal {
        string region;
        string vaccineType;
        string threatVector;
        bool treatyAligned;
        bool restorationActivated;
        uint256 timestamp;
    }

    PulseSignal[] public signals;

    event HealthSanctumPulseRouted(string region, string vaccineType, string threatVector, bool treatyAligned, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routePulse(string memory region, string memory vaccineType, string memory threatVector, bool treatyAligned, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(PulseSignal(region, vaccineType, threatVector, treatyAligned, restorationActivated, block.timestamp));
        emit HealthSanctumPulseRouted(region, vaccineType, threatVector, treatyAligned, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        PulseSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.threatVector, s.treatyAligned, s.restorationActivated, s.timestamp);
    }
}
