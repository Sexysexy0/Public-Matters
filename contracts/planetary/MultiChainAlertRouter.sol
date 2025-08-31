// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract MultiChainAlertRouter {
    struct Alert {
        string originSanctum;
        string actor;
        string breachType;
        uint timestamp;
        bool resolved;
    }

    Alert[] public alerts;

    event AlertBroadcasted(string originSanctum, string actor, string breachType);
    event AlertResolved(string actor);

    function broadcastAlert(
        string memory _originSanctum,
        string memory _actor,
        string memory _breachType
    ) public {
        alerts.push(Alert(_originSanctum, _actor, _breachType, block.timestamp, false));
        emit AlertBroadcasted(_originSanctum, _actor, _breachType);
    }

    function resolveAlert(uint index) public {
        require(index < alerts.length, "Invalid index");
        alerts[index].resolved = true;
        emit AlertResolved(alerts[index].actor);
    }

    function getAllAlerts() public view returns (Alert[] memory) {
        return alerts;
    }
}
