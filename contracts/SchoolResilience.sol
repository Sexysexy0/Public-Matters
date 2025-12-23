// contracts/SchoolResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SchoolResilience
 * @notice Logs school capacity and resilience measures.
 */
contract SchoolResilience {
    address public admin;

    struct School {
        string name;
        uint256 capacity;
        string status;   // "Operational", "Overcrowded", "UnderRepair"
        uint256 timestamp;
    }

    School[] public schools;

    event SchoolLogged(string name, uint256 capacity, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSchool(string calldata name, uint256 capacity, string calldata status) external onlyAdmin {
        schools.push(School(name, capacity, status, block.timestamp));
        emit SchoolLogged(name, capacity, status, block.timestamp);
    }

    function totalSchools() external view returns (uint256) { return schools.length; }

    function getSchool(uint256 id) external view returns (School memory) {
        require(id < schools.length, "Invalid id");
        return schools[id];
    }
}
