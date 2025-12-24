// contracts/TransparencyCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TransparencyCommons
 * @notice Logs communal transparency initiatives in media and governance.
 */
contract TransparencyCommons {
    address public admin;

    struct Initiative {
        string name;        // "OpenDataPortal", "FactCheckHub"
        string description;
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInitiative(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        initiatives.push(Initiative(name, description, status, block.timestamp));
        emit InitiativeLogged(name, description, status, block.timestamp);
    }

    function totalInitiatives() external view returns (uint256) { return initiatives.length; }

    function getInitiative(uint256 id) external view returns (Initiative memory) {
        require(id < initiatives.length, "Invalid id");
        return initiatives[id];
    }
}
