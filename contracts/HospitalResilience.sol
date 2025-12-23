// contracts/HospitalResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HospitalResilience
 * @notice Logs hospital capacity and resilience measures.
 */
contract HospitalResilience {
    address public admin;

    struct Hospital {
        string name;
        uint256 capacity;
        string status;   // "Operational", "Overloaded", "UnderRepair"
        uint256 timestamp;
    }

    Hospital[] public hospitals;

    event HospitalLogged(string name, uint256 capacity, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logHospital(string calldata name, uint256 capacity, string calldata status) external onlyAdmin {
        hospitals.push(Hospital(name, capacity, status, block.timestamp));
        emit HospitalLogged(name, capacity, status, block.timestamp);
    }

    function totalHospitals() external view returns (uint256) { return hospitals.length; }

    function getHospital(uint256 id) external view returns (Hospital memory) {
        require(id < hospitals.length, "Invalid id");
        return hospitals[id];
    }
}
