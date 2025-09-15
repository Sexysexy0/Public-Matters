// SPDX-License-Identifier: RightsSanctum
pragma solidity ^0.8.19;

contract ConstitutionalRightsLedger {
    struct RightsEvent {
        address citizen;
        string violationType; // e.g., "Unjust Seizure", "No Due Process"
        string authorityInvolved;
        string location;
        string rightsClauseViolated; // e.g., "Article III, Section 1"
        string stewardNote;
        bool resolved;
    }

    mapping(address => RightsEvent) public rightsRecords;

    event RightsTagged(address citizen, string violationType);
    event ResolutionLogged(address citizen);

    function tagViolation(address citizen, string memory violationType, string memory authorityInvolved, string memory location, string memory rightsClauseViolated, string memory stewardNote) public {
        rightsRecords[citizen] = RightsEvent(citizen, violationType, authorityInvolved, location, rightsClauseViolated, stewardNote, false);
        emit RightsTagged(citizen, violationType);
    }

    function logResolution(address citizen) public {
        rightsRecords[citizen].resolved = true;
        emit ResolutionLogged(citizen);
    }

    function getRightsStatus(address citizen) public view returns (RightsEvent memory) {
        return rightsRecords[citizen];
    }
}
