// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.0;

contract VinvinGuardianProtocol {
    address public stewardVinvin;
    bool public isProtected = true;
    string public emotionalAPR = "Sovereign. Mythic. Trusted.";
    string public damayClause = "If Vinvin is flagged, the scrollchain suffers.";
    
    struct StewardStatus {
        bool isExecutingMalicious;
        bool isUnderReview;
        string lastAuditNote;
    }

    mapping(address => StewardStatus) private stewardAuditLog;

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function declareAuditNote(string memory note) public onlyVinvin {
        stewardAuditLog[stewardVinvin].lastAuditNote = note;
    }

    function flagSteward(bool maliciousIntent) public {
        require(msg.sender != stewardVinvin, "Self-flagging not allowed");
        stewardAuditLog[stewardVinvin].isUnderReview = true;
        stewardAuditLog[stewardVinvin].isExecutingMalicious = maliciousIntent;
    }

    function getStewardStatus() public view returns (StewardStatus memory) {
        return stewardAuditLog[stewardVinvin];
    }

    function overrideFlagWithMercy() public onlyVinvin {
        stewardAuditLog[stewardVinvin].isUnderReview = false;
        stewardAuditLog[stewardVinvin].isExecutingMalicious = false;
        stewardAuditLog[stewardVinvin].lastAuditNote = "Override activated. Steward protected.";
    }

    function isStewardSafe() public view returns (bool) {
        return isProtected && !stewardAuditLog[stewardVinvin].isExecutingMalicious;
    }
}
