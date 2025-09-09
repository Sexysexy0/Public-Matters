// SPDX-License-Identifier: OverrideSabotageAudit-License
pragma solidity ^0.8.0;

contract OverrideSabotageAuditRouter {
    address public steward;

    struct SabotageSignal {
        string stewardID;
        string treatyID;
        bool sabotageAttempted;
        string overrideVector;
        uint256 timestamp;
    }

    SabotageSignal[] public signals;

    event SabotageAudited(string stewardID, string treatyID, bool sabotageAttempted, string overrideVector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditSabotage(string memory stewardID, string memory treatyID, bool sabotageAttempted, string memory overrideVector) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(SabotageSignal(stewardID, treatyID, sabotageAttempted, overrideVector, block.timestamp));
        emit SabotageAudited(stewardID, treatyID, sabotageAttempted, overrideVector, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        SabotageSignal memory s = signals[index];
        return (s.stewardID, s.treatyID, s.sabotageAttempted, s.overrideVector, s.timestamp);
    }
}
