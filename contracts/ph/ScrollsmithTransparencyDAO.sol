// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollsmithTransparencyDAO {
    struct Proposal {
        string title;
        string description;
        bool isApproved;
    }

    Proposal[] public proposals;
    mapping(address => bool) public barangayAuditors;

    modifier onlyAuditor() {
        require(barangayAuditors[msg.sender], "Not a certified barangay auditor");
        _;
    }

    function certifyAuditor(address _auditor) public {
        barangayAuditors[_auditor] = true;
    }

    function submitProposal(string memory _title, string memory _description) public onlyAuditor {
        proposals.push(Proposal(_title, _description, false));
    }

    function approveProposal(uint _index) public onlyAuditor {
        proposals[_index].isApproved = true;
    }

    function getProposal(uint _index) public view returns (Proposal memory) {
        return proposals[_index];
    }
}
