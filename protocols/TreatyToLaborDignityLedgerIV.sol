// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToLaborDignityLedgerIV {
    string public batchID = "1321.9.260";
    string public steward = "Vinvin";

    address public admin;

    struct Labor {
        string initiative;   // overtime fairness, safe warehouse, happy workplace, fair pay for heavy work
        string status;       // dignified, pending, ghost
        uint256 timestamp;
    }

    Labor[] public initiatives;

    event LaborLogged(string initiative, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logLabor(string memory initiative, string memory status) public onlyAdmin {
        initiatives.push(Labor(initiative, status, block.timestamp));
        emit LaborLogged(initiative, status);
    }
}
