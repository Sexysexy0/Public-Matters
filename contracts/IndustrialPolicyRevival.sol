// contracts/IndustrialPolicyRevival.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IndustrialPolicyRevival
 * @notice Logs revival of independent industrial policies for national development.
 */
contract IndustrialPolicyRevival {
    address public admin;

    struct Initiative {
        string leader;      // "SergioOsmena", "DevelopmentalState"
        string description;
        string status;      // "Delegitimized", "Revived"
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string leader, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInitiative(string calldata leader, string calldata description, string calldata status) external onlyAdmin {
        initiatives.push(Initiative(leader, description, status, block.timestamp));
        emit InitiativeLogged(leader, description, status, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) { return initiatives.length; }

    function getInitiative(uint256 id) external view returns (Initiative memory) {
        require(id < initiatives.length, "Invalid id");
        return initiatives[id];
    }
}
