// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToCivicProgramsAuditLedger {
    string public batchID = "1321.9.250";
    string public steward = "Vinvin";

    address public admin;

    struct CivicProgram {
        string initiative;   // volunteer drive, mentorship, skills training
        string status;       // audited, pending, ghost
        uint256 timestamp;
    }

    CivicProgram[] public initiatives;

    event CivicProgramLogged(string initiative, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logInitiative(string memory initiative, string memory status) public onlyAdmin {
        initiatives.push(CivicProgram(initiative, status, block.timestamp));
        emit CivicProgramLogged(initiative, status);
    }

    function getInitiative(uint256 index) public view returns (string memory initiative, string memory status, uint256 timestamp) {
        CivicProgram memory c = initiatives[index];
        return (c.initiative, c.status, c.timestamp);
    }
}
