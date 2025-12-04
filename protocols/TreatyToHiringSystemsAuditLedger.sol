// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToHiringSystemsAuditLedger {
    string public batchID = "1321.9.243";
    string public steward = "Vinvin";

    address public admin;

    struct Hiring {
        string company;     // employer name
        string status;      // audited, pending, ghost
        uint256 timestamp;
    }

    Hiring[] public hirings;

    event HiringLogged(string company, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logHiring(string memory company, string memory status) public onlyAdmin {
        hirings.push(Hiring(company, status, block.timestamp));
        emit HiringLogged(company, status);
    }

    function getHiring(uint256 index) public view returns (string memory company, string memory status, uint256 timestamp) {
        Hiring memory h = hirings[index];
        return (h.company, h.status, h.timestamp);
    }
}
