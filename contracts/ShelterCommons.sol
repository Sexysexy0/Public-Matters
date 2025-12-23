// contracts/ShelterCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ShelterCommons
 * @notice Communal shelters for displaced families and disaster resilience.
 */
contract ShelterCommons {
    address public admin;

    struct Shelter {
        string name;
        uint256 capacity;
        string status;   // "Available", "Full", "UnderRepair"
        uint256 timestamp;
    }

    Shelter[] public shelters;

    event ShelterLogged(string name, uint256 capacity, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logShelter(string calldata name, uint256 capacity, string calldata status) external onlyAdmin {
        shelters.push(Shelter(name, capacity, status, block.timestamp));
        emit ShelterLogged(name, capacity, status, block.timestamp);
    }

    function totalShelters() external view returns (uint256) { return shelters.length; }

    function getShelter(uint256 id) external view returns (Shelter memory) {
        require(id < shelters.length, "Invalid id");
        return shelters[id];
    }
}
