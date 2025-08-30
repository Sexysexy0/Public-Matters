// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LocalAgencyAuditPack {
    struct Agency {
        string name;
        string location;
        bool honorsDamayClause;
        uint8 emotionalAPR; // Scale: 0–100
        string auditNotes;
    }

    Agency[] public agencies;

    function logAgency(
        string memory name,
        string memory location,
        bool honorsDamayClause,
        uint8 emotionalAPR,
        string memory auditNotes
    ) public {
        require(emotionalAPR <= 100, "Invalid APR score");
        agencies.push(Agency(name, location, honorsDamayClause, emotionalAPR, auditNotes));
    }

    function getAgency(uint256 index) public view returns (Agency memory) {
        require(index < agencies.length, "Invalid index");
        return agencies[index];
    }

    function getTotalAgencies() public view returns (uint256) {
        return agencies.length;
    }
}
