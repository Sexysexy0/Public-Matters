// contracts/ResilienceRegistry.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ResilienceRegistry {
    struct Incident {
        address pair;
        string label;
        uint256 timestamp;
        address reporter;
    }

    Incident[] public incidents;
    mapping(address => bool) public guardians;
    address public owner;

    event GuardianSet(address indexed account, bool status);
    event IncidentLogged(uint256 indexed id, address indexed pair, string label);

    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    modifier onlyGuardian() { require(guardians[msg.sender], "Not guardian"); _; }

    constructor() {
        owner = msg.sender;
        guardians[msg.sender] = true;
        emit GuardianSet(msg.sender, true);
    }

    function setGuardian(address account, bool status) external onlyOwner {
        guardians[account] = status;
        emit GuardianSet(account, status);
    }

    function logIncident(address pair, string calldata label) external onlyGuardian returns (uint256 id) {
        incidents.push(Incident({
            pair: pair,
            label: label,
            timestamp: block.timestamp,
            reporter: msg.sender
        }));
        id = incidents.length - 1;
        emit IncidentLogged(id, pair, label);
    }

    function totalIncidents() external view returns (uint256) {
        return incidents.length;
    }

    function getIncident(uint256 id) external view returns (Incident memory) {
        require(id < incidents.length, "Invalid incident id");
        return incidents[id];
    }
}
