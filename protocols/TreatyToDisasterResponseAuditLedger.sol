// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToDisasterResponseAuditLedger {
    string public batchID = "1321.9.245";
    string public steward = "Vinvin";

    address public admin;

    struct Response {
        string system;     // evacuation, relief distribution, early warning
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    Response[] public responses;

    event ResponseLogged(string system, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logResponse(string memory system, string memory status) public onlyAdmin {
        responses.push(Response(system, status, block.timestamp));
        emit ResponseLogged(system, status);
    }

    function getResponse(uint256 index) public view returns (string memory system, string memory status, uint256 timestamp) {
        Response memory r = responses[index];
        return (r.system, r.status, r.timestamp);
    }
}
