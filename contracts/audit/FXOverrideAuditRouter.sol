// SPDX-License-Identifier: FXOverrideAudit-License
pragma solidity ^0.8.0;

contract FXOverrideAuditRouter {
    address public steward;

    struct AuditSignal {
        string originPair;
        string reroutedPair;
        bool overrideConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event FXOverrideAudited(string originPair, string reroutedPair, bool overrideConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditOverride(string memory originPair, string memory reroutedPair, bool overrideConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(AuditSignal(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp));
        emit FXOverrideAudited(originPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        AuditSignal memory s = signals[index];
        return (s.originPair, s.reroutedPair, s.overrideConfirmed, s.blessingType, s.timestamp);
    }
}
