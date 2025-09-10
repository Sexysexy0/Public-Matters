// SPDX-License-Identifier: VisaContinuityAudit-License
pragma solidity ^0.8.0;

contract VisaContinuityAuditRouter {
    address public steward;

    struct AuditSignal {
        string immigrantID;
        string hostNation;
        string visaCategory;
        string disruptionType;
        string continuityScore;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event VisaContinuityAudited(string immigrantID, string hostNation, string visaCategory, string disruptionType, string continuityScore, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditVisa(string memory immigrantID, string memory hostNation, string memory visaCategory, string memory disruptionType, string memory continuityScore) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(AuditSignal(immigrantID, hostNation, visaCategory, disruptionType, continuityScore, block.timestamp));
        emit VisaContinuityAudited(immigrantID, hostNation, visaCategory, disruptionType, continuityScore, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, string memory, uint256) {
        AuditSignal memory s = signals[index];
        return (s.immigrantID, s.hostNation, s.visaCategory, s.disruptionType, s.continuityScore, s.timestamp);
    }
}
