// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumEchoFeed {
    struct EchoEvent {
        string eventType; // "Onboarding", "Blessing", "Succession", "Restoration"
        string unitID;
        string barangay;
        string emotionalTag; // "SanctumGlow", "DamayClause", "AuditGlow", "BlessingPulse"
        string stewardID;
        uint256 timestamp;
    }

    EchoEvent[] public echoLog;

    event EchoBroadcasted(string eventType, string unitID, string barangay, string emotionalTag, string stewardID, uint256 timestamp);

    function broadcastEcho(
        string memory _eventType,
        string memory _unitID,
        string memory _barangay,
        string memory _emotionalTag,
        string memory _stewardID
    ) public {
        EchoEvent memory newEcho = EchoEvent({
            eventType: _eventType,
            unitID: _unitID,
            barangay: _barangay,
            emotionalTag: _emotionalTag,
            stewardID: _stewardID,
            timestamp: block.timestamp
        });

        echoLog.push(newEcho);
        emit EchoBroadcasted(_eventType, _unitID, _barangay, _emotionalTag, _stewardID, block.timestamp);
    }

    function getEchoLog() public view returns (EchoEvent[] memory) {
        return echoLog;
    }
}
