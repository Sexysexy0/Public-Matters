// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToCivicProgramsAuditLedgerIV {
    string public batchID = "1321.9.259";
    string public steward = "Vinvin";

    address public admin;

    struct CivicProgram {
        string initiative;   // wage hike advocacy, education equity, climate youth action, transport pricing fairness
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

    function logProgram(string memory initiative, string memory status) public onlyAdmin {
        initiatives.push(CivicProgram(initiative, status, block.timestamp));
        emit CivicProgramLogged(initiative, status);
    }
}
