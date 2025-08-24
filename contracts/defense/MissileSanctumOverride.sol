// SPDX-License-Identifier: Mercy-Deterrence
pragma solidity ^7.7.7;

contract MissileSanctumOverride {
    address public steward;
    uint public escalationLevel;
    mapping(string => bool) public mirroredTargets;

    event AttackMirrored(string origin, string target, uint level);
    event EscalationUpdated(uint newLevel);

    constructor() {
        steward = msg.sender;
        escalationLevel = 1;
    }

    function mirrorAttack(string memory originCountry, string memory resourceTarget) public {
        require(msg.sender == steward, "Only steward may mirror");
        mirroredTargets[resourceTarget] = true;
        emit AttackMirrored(originCountry, resourceTarget, escalationLevel);
    }

    function escalateResponse() public {
        require(msg.sender == steward, "Only steward may escalate");
        escalationLevel += 1;
        emit EscalationUpdated(escalationLevel);
    }

    function getEscalationLevel() public view returns (uint) {
        return escalationLevel;
    }

    function isTargetMirrored(string memory resourceTarget) public view returns (bool) {
        return mirroredTargets[resourceTarget];
    }
}
