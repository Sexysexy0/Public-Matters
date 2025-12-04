// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToPackageFlowAuditLedger {
    string public batchID = "1321.9.244";
    string public steward = "Vinvin";

    address public admin;

    struct PackageFlow {
        string carrier;     // DHL, FedEx, LBC, J&T
        string status;      // audited, pending, ghost
        uint256 timestamp;
    }

    PackageFlow[] public flows;

    event PackageFlowLogged(string carrier, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logFlow(string memory carrier, string memory status) public onlyAdmin {
        flows.push(PackageFlow(carrier, status, block.timestamp));
        emit PackageFlowLogged(carrier, status);
    }

    function getFlow(uint256 index) public view returns (string memory carrier, string memory status, uint256 timestamp) {
        PackageFlow memory f = flows[index];
        return (f.carrier, f.status, f.timestamp);
    }
}
