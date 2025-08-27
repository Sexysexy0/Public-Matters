// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.27;

contract SierraMadreSentinel {
    address public steward;
    mapping(address => bool) public rogueDetected;
    mapping(address => string) public violationLog;

    event IncursionLogged(address intruder, string reason);
    event DefenseActivated(address intruder);
    event BroadcastSynced(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logIncursion(address intruder, string memory reason) external onlySteward {
        rogueDetected[intruder] = true;
        violationLog[intruder] = reason;
        emit IncursionLogged(intruder, reason);
    }

    function activateDefense(address intruder) external onlySteward {
        require(rogueDetected[intruder], "No incursion detected.");
        emit DefenseActivated(intruder);
    }

    function syncBroadcast(string memory message) external onlySteward {
        emit BroadcastSynced(message);
    }

    function isRogue(address intruder) external view returns (bool) {
        return rogueDetected[intruder];
    }

    function getViolationReason(address intruder) external view returns (string memory) {
        return violationLog[intruder];
    }
}
