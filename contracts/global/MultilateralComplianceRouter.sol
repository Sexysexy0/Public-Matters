// SPDX-License-Identifier: TreatyComplianceSanctum
pragma solidity ^0.8.19;

contract MultilateralComplianceRouter {
    struct ComplianceEvent {
        string country;
        string treatyName;
        bool debtObligationMet;
        bool collateralVerified;
        string complianceNote;
        bool flagged;
    }

    mapping(bytes32 => ComplianceEvent) public events;

    event TreatyComplianceTagged(string country, string treatyName);
    event ComplianceFlagged(string country, string complianceNote);

    function tagCompliance(string memory country, string memory treatyName, bool debtObligationMet, bool collateralVerified, string memory complianceNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, treatyName, block.timestamp));
        events[eventId] = ComplianceEvent(country, treatyName, debtObligationMet, collateralVerified, complianceNote, false);
        emit TreatyComplianceTagged(country, treatyName);
    }

    function flagNonCompliance(string memory country, string memory treatyName, string memory complianceNote) public {
        bytes32 eventId = keccak256(abi.encodePacked(country, treatyName, block.timestamp));
        events[eventId].flagged = true;
        events[eventId].complianceNote = complianceNote;
        emit ComplianceFlagged(country, complianceNote);
    }

    function getComplianceStatus(string memory country, string memory treatyName) public view returns (ComplianceEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(country, treatyName, block.timestamp));
        return events[eventId];
    }
}
