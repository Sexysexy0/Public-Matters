// contracts/NuclearStewardship.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NuclearStewardship
 * @notice Protocol for nuclear energy stewardship and communal audit.
 */
contract NuclearStewardship {
    address public admin;

    struct Facility {
        string name;
        uint256 capacity;   // MW
        string safetyNote;
        uint256 timestamp;
    }

    Facility[] public facilities;

    event FacilityLogged(string name, uint256 capacity, string safetyNote, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logFacility(string calldata name, uint256 capacity, string calldata safetyNote) external onlyAdmin {
        facilities.push(Facility(name, capacity, safetyNote, block.timestamp));
        emit FacilityLogged(name, capacity, safetyNote, block.timestamp);
    }

    function totalFacilities() external view returns (uint256) {
        return facilities.length;
    }

    function getFacility(uint256 id) external view returns (Facility memory) {
        require(id < facilities.length, "Invalid id");
        return facilities[id];
    }
}
