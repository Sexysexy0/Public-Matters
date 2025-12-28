// contracts/MedicalAccess.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MedicalAccess
 * @notice Logs communal healthcare access and equity in medical systems.
 */
contract MedicalAccess {
    address public admin;

    struct Access {
        string service;     // "PrimaryCare", "Emergency", "Insurance"
        string status;      // "Available", "Limited", "Unavailable"
        uint256 timestamp;
    }

    Access[] public accesses;

    event AccessLogged(string service, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAccess(string calldata service, string calldata status) external onlyAdmin {
        accesses.push(Access(service, status, block.timestamp));
        emit AccessLogged(service, status, block.timestamp);
    }

    function totalAccesses() external view returns (uint256) { return accesses.length; }

    function getAccess(uint256 id) external view returns (Access memory) {
        require(id < accesses.length, "Invalid id");
        return accesses[id];
    }
}
