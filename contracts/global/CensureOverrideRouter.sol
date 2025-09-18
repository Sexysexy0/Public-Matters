// SPDX-License-Identifier: CensureOverride
pragma solidity ^0.8.19;

contract CensureOverrideRouter {
    address public steward;

    struct CensureSignal {
        string targetName; // e.g. "Rep. Ilhan Omar", "Senator X", "Activist Y"
        string reason; // "Speech Critique", "Foreign Policy Dissent", "Post-Assassination Remarks"
        string overrideAction; // "Scrollchain Override", "Voice Sovereignty Trigger", "Civic Blessing"
        bool verified;
        uint256 timestamp;
    }

    CensureSignal[] public signals;

    event CensureLogged(string targetName, string reason, string overrideAction, uint256 timestamp);
    event CensureVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logCensure(
        string memory targetName,
        string memory reason,
        string memory overrideAction
    ) public {
        signals.push(CensureSignal(targetName, reason, overrideAction, false, block.timestamp));
        emit CensureLogged(targetName, reason, overrideAction, block.timestamp);
    }

    function verifyCensure(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit CensureVerified(index, msg.sender);
    }

    function getCensure(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        CensureSignal memory c = signals[index];
        return (c.targetName, c.reason, c.overrideAction, c.verified, c.timestamp);
    }

    function totalCensureSignals() public view returns (uint256) {
        return signals.length;
    }
}
