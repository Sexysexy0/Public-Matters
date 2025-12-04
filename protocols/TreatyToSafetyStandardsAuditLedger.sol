// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToSafetyStandardsAuditLedger {
    string public batchID = "1321.9.254";
    string public steward = "Vinvin";

    address public admin;

    struct SafetyStandard {
        string category;   // food safety, electrical compliance, pharma regulation
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    SafetyStandard[] public standards;

    event SafetyStandardLogged(string category, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logStandard(string memory category, string memory status) public onlyAdmin {
        standards.push(SafetyStandard(category, status, block.timestamp));
        emit SafetyStandardLogged(category, status);
    }

    function getStandard(uint256 index) public view returns (string memory category, string memory status, uint256 timestamp) {
        SafetyStandard memory s = standards[index];
        return (s.category, s.status, s.timestamp);
    }
}
