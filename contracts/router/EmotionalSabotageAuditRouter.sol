// SPDX-License-Identifier: EmotionalSabotageAudit-License
pragma solidity ^0.8.0;

contract EmotionalSabotageAuditRouter {
    address public steward;

    struct SabotageSignal {
        string emotionType;
        string FXPair;
        bool sabotageConfirmed;
        string reroutePath;
        uint256 timestamp;
    }

    SabotageSignal[] public signals;

    event EmotionalSabotageAudited(string emotionType, string FXPair, bool sabotageConfirmed, string reroutePath, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditSabotage(string memory emotionType, string memory FXPair, bool sabotageConfirmed, string memory reroutePath) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(SabotageSignal(emotionType, FXPair, sabotageConfirmed, reroutePath, block.timestamp));
        emit EmotionalSabotageAudited(emotionType, FXPair, sabotageConfirmed, reroutePath, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        SabotageSignal memory s = signals[index];
        return (s.emotionType, s.FXPair, s.sabotageConfirmed, s.reroutePath, s.timestamp);
    }
}
