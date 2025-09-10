// SPDX-License-Identifier: PWDSanctumActivation-License
pragma solidity ^0.8.0;

contract PWDSanctumActivationRouter {
    address public steward;

    struct ActivationSignal {
        string region;
        string sector;
        uint256 jobsCreated;
        bool accessibilityUpgraded;
        bool dignityConfirmed;
        uint256 timestamp;
    }

    ActivationSignal[] public signals;

    event PWDSanctumActivated(string region, string sector, uint256 jobsCreated, bool accessibilityUpgraded, bool dignityConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function activateSanctum(string memory region, string memory sector, uint256 jobsCreated, bool accessibilityUpgraded, bool dignityConfirmed) public {
        require(msg.sender == steward, "Only steward can activate");
        signals.push(ActivationSignal(region, sector, jobsCreated, accessibilityUpgraded, dignityConfirmed, block.timestamp));
        emit PWDSanctumActivated(region, sector, jobsCreated, accessibilityUpgraded, dignityConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, uint256, bool, bool, uint256) {
        ActivationSignal memory s = signals[index];
        return (s.region, s.sector, s.jobsCreated, s.accessibilityUpgraded, s.dignityConfirmed, s.timestamp);
    }
}
