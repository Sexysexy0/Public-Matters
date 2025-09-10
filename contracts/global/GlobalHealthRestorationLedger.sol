// SPDX-License-Identifier: GlobalHealthRestorationLedger-License
pragma solidity ^0.8.0;

contract GlobalHealthRestorationLedger {
    address public steward;

    struct RestorationSignal {
        string region;
        string vaccineType;
        string equityScore;
        bool publicTrustConfirmed;
        bool treatyAligned;
        uint256 timestamp;
    }

    RestorationSignal[] public signals;

    event HealthRestorationLogged(string region, string vaccineType, string equityScore, bool publicTrustConfirmed, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logRestoration(string memory region, string memory vaccineType, string memory equityScore, bool publicTrustConfirmed, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can log");
        signals.push(RestorationSignal(region, vaccineType, equityScore, publicTrustConfirmed, treatyAligned, block.timestamp));
        emit HealthRestorationLogged(region, vaccineType, equityScore, publicTrustConfirmed, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        RestorationSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.equityScore, s.publicTrustConfirmed, s.treatyAligned, s.timestamp);
    }
}
