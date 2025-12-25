// contracts/BaseLease.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BaseLease
 * @notice Logs military base lease agreements and communal sovereignty arcs.
 */
contract BaseLease {
    address public admin;

    struct Lease {
        string base;        // "Diego Garcia"
        string lessor;      // "UK", "Mauritius"
        string lessee;      // "US"
        uint256 duration;   // in years
        string status;      // "Active", "Pending", "Terminated"
        uint256 timestamp;
    }

    Lease[] public leases;

    event LeaseLogged(string base, string lessor, string lessee, uint256 duration, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logLease(string calldata base, string calldata lessor, string calldata lessee, uint256 duration, string calldata status) external onlyAdmin {
        leases.push(Lease(base, lessor, lessee, duration, status, block.timestamp));
        emit LeaseLogged(base, lessor, lessee, duration, status, block.timestamp);
    }

    function totalLeases() external view returns (uint256) { return leases.length; }

    function getLease(uint256 id) external view returns (Lease memory) {
        require(id < leases.length, "Invalid id");
        return leases[id];
    }
}
