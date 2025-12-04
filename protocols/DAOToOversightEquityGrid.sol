// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract DAOToOversightEquityGrid {
    string public batchID = "1321.9.251";
    string public steward = "Vinvin";

    address public admin;

    struct Oversight {
        string domain;     // finance, education, infrastructure, energy
        string status;     // equitable, pending, ghost
        uint256 timestamp;
    }

    Oversight[] public domains;

    event OversightLogged(string domain, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logDomain(string memory domain, string memory status) public onlyAdmin {
        domains.push(Oversight(domain, status, block.timestamp));
        emit OversightLogged(domain, status);
    }

    function getDomain(uint256 index) public view returns (string memory domain, string memory status, uint256 timestamp) {
        Oversight memory o = domains[index];
        return (o.domain, o.status, o.timestamp);
    }
}
