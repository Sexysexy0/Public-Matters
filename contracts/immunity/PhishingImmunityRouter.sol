// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PhishingImmunityRouter {
    struct MaintainerRecord {
        string maintainerId;
        string name;
        bool passedSimulation;
        uint256 lastPhishingTimestamp;
        string affectedPackages;
    }

    mapping(string => MaintainerRecord) public immunityLedger;

    event MaintainerLogged(string maintainerId, string name, bool passedSimulation);

    function logMaintainer(
        string memory maintainerId,
        string memory name,
        bool passedSimulation,
        uint256 lastPhishingTimestamp,
        string memory affectedPackages
    ) public {
        immunityLedger[maintainerId] = MaintainerRecord(
            maintainerId,
            name,
            passedSimulation,
            lastPhishingTimestamp,
            affectedPackages
        );

        emit MaintainerLogged(maintainerId, name, passedSimulation);
    }

    function getMaintainerDetails(string memory maintainerId) public view returns (MaintainerRecord memory) {
        return immunityLedger[maintainerId];
    }
}
