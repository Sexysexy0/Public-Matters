// SPDX-License-Identifier: VaccineSanctumContinuity-License
pragma solidity ^0.8.0;

contract VaccineSanctumContinuityRouter {
    address public steward;

    struct ContinuitySignal {
        string region;
        string vaccineType;
        bool publicTrustConfirmed;
        bool continuityActivated;
        uint256 timestamp;
    }

    ContinuitySignal[] public signals;

    event VaccineSanctumContinuityRouted(string region, string vaccineType, bool publicTrustConfirmed, bool continuityActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory region, string memory vaccineType, bool publicTrustConfirmed, bool continuityActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ContinuitySignal(region, vaccineType, publicTrustConfirmed, continuityActivated, block.timestamp));
        emit VaccineSanctumContinuityRouted(region, vaccineType, publicTrustConfirmed, continuityActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, uint256) {
        ContinuitySignal memory s = signals[index];
        return (s.region, s.vaccineType, s.publicTrustConfirmed, s.continuityActivated, s.timestamp);
    }
}
