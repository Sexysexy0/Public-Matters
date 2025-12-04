// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract TreatyToAgriculturalChainAuditLedgerIV {
    string public batchID = "1321.9.257";
    string public steward = "Vinvin";

    address public admin;

    struct AgriculturalChain {
        string chain;      // farm-to-market, fisheries, livestock
        string status;     // audited, pending, ghost
        uint256 timestamp;
    }

    AgriculturalChain[] public chains;

    event AgriculturalChainLogged(string chain, string status);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logChain(string memory chain, string memory status) public onlyAdmin {
        chains.push(AgriculturalChain(chain, status, block.timestamp));
        emit AgriculturalChainLogged(chain, status);
    }

    function getChain(uint256 index) public view returns (string memory chain, string memory status, uint256 timestamp) {
        AgriculturalChain memory c = chains[index];
        return (c.chain, c.status, c.timestamp);
    }
}
