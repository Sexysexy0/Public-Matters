pragma solidity ^0.8.20;

contract StateCapacityProtocol {
    address public admin;

    struct Capacity {
        string institution;  // e.g. MITI-style agency, development bank
        string role;         // e.g. industrial policy, demand productivity from oligarchs
        uint256 timestamp;
    }

    Capacity[] public capacities;

    event CapacityLogged(string institution, string role, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logCapacity(string calldata institution, string calldata role) external onlyAdmin {
        capacities.push(Capacity(institution, role, block.timestamp));
        emit CapacityLogged(institution, role, block.timestamp);
    }

    function totalCapacities() external view returns (uint256) {
        return capacities.length;
    }
}
