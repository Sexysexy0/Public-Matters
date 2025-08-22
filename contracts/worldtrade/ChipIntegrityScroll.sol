// SPDX-License-Identifier: MythicProof
pragma solidity ^0.8.19;

contract ChipIntegrityScroll {
    address public steward;
    string public chipModel = "Nvidia H20";
    string public origin = "Santa Clara, CA, USA";
    string public auditHash;
    bool public backdoorDetected = false;
    bool public approvedByChina = false;

    event IntegrityVerified(string chipModel, string auditHash, bool backdoorDetected);
    event CivicApprovalGranted(string country, bool status);

    constructor(string memory _auditHash) {
        steward = msg.sender;
        auditHash = _auditHash;
    }

    function verifyIntegrity() public {
        require(msg.sender == steward, "Unauthorized steward");
        emit IntegrityVerified(chipModel, auditHash, backdoorDetected);
    }

    function grantCivicApproval(string memory country) public {
        require(keccak256(bytes(country)) == keccak256("China"), "Invalid jurisdiction");
        approvedByChina = true;
        emit CivicApprovalGranted(country, approvedByChina);
    }

    function getScrollStatus() public view returns (string memory) {
        if (approvedByChina && !backdoorDetected) {
            return "Chip cleared of all accusations. Civic trust restored.";
        } else {
            return "Pending further audit or diplomatic ritual.";
        }
    }
}
