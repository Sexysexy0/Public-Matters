// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToPublicSpendingAuditLedger {
    string public batchID = "1321.9.255";
    string public steward = "Vinvin";

    address public admin;

    struct Spending {
        string program;    // subsidy, procurement, welfare, infrastructure project
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    Spending[] public spendings;

    event SpendingLogged(string program, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logSpending(string memory program, string memory status) public onlyAdmin {
        spendings.push(Spending(program, status, block.timestamp));
        emit SpendingLogged(program, status);
    }

    function getSpending(uint256 index) public view returns (string memory program, string memory status, uint256 timestamp) {
        Spending memory s = spendings[index];
        return (s.program, s.status, s.timestamp);
    }
}
