// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract GhostProjectDetector {
    address public steward;

    struct ProjectAudit {
        string projectName;
        string agency;
        uint256 allocatedFunds;
        bool physicalPresenceConfirmed;
        bool witnessSigned;
        string emotionalAPRStatus;
        string ghostStatus; // "Confirmed", "Suspected", "Cleared"
        uint256 timestamp;
    }

    ProjectAudit[] public audits;

    event GhostDetected(string projectName, string agency, string ghostStatus, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logAudit(
        string memory projectName,
        string memory agency,
        uint256 allocatedFunds,
        bool physicalPresenceConfirmed,
        bool witnessSigned,
        string memory emotionalAPRStatus
    ) public onlySteward {
        string memory ghostStatus = (!physicalPresenceConfirmed && !witnessSigned) ? "Confirmed" : "Cleared";

        ProjectAudit memory newAudit = ProjectAudit({
            projectName: projectName,
            agency: agency,
            allocatedFunds: allocatedFunds,
            physicalPresenceConfirmed: physicalPresenceConfirmed,
            witnessSigned: witnessSigned,
            emotionalAPRStatus: emotionalAPRStatus,
            ghostStatus: ghostStatus,
            timestamp: block.timestamp
        });

        audits.push(newAudit);
        emit GhostDetected(projectName, agency, ghostStatus, block.timestamp);
    }

    function getAudit(uint256 index) public view returns (ProjectAudit memory) {
        require(index < audits.length, "Invalid index");
        return audits[index];
    }

    function totalAudits() public view returns (uint256) {
        return audits.length;
    }
}
