// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToHousingSystemsAuditLedger {
    string public batchID = "1321.9.253";
    string public steward = "Vinvin";

    address public admin;

    struct HousingSystem {
        string system;     // zoning, rent control, subsidy distribution
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    HousingSystem[] public systems;

    event HousingSystemLogged(string system, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logSystem(string memory system, string memory status) public onlyAdmin {
        systems.push(HousingSystem(system, status, block.timestamp));
        emit HousingSystemLogged(system, status);
    }

    function getSystem(uint256 index) public view returns (string memory system, string memory status, uint256 timestamp) {
        HousingSystem memory h = systems[index];
        return (h.system, h.status, h.timestamp);
    }
}
