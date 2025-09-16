// SPDX-License-Identifier: ImmigrationSanctum
pragma solidity ^0.8.19;

contract ImmigrationComplaintRouter {
    struct ComplaintSignal {
        address respondent;
        string complaintType; // e.g., "Visa Violation", "Unjust Deportation", "Blacklist Error"
        string jurisdiction;
        bool resolved;
        string stewardNote;
    }

    mapping(address => ComplaintSignal) public complaintRegistry;

    event ComplaintFiled(address respondent, string complaintType);
    event ComplaintResolved(address respondent);

    function fileComplaint(address respondent, string memory complaintType, string memory jurisdiction, string memory stewardNote) public {
        complaintRegistry[respondent] = ComplaintSignal(respondent, complaintType, jurisdiction, false, stewardNote);
        emit ComplaintFiled(respondent, complaintType);
    }

    function resolveComplaint(address respondent) public {
        require(bytes(complaintRegistry[respondent].complaintType).length > 0, "Complaint not found");
        complaintRegistry[respondent].resolved = true;
        emit ComplaintResolved(respondent);
    }

    function getComplaintStatus(address respondent) public view returns (ComplaintSignal memory) {
        return complaintRegistry[respondent];
    }
}
