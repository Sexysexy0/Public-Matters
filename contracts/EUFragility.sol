// contracts/EUFragility.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EUFragility
 * @notice Protocol for tracking vulnerabilities and crises within the European Union.
 */
contract EUFragility {
    address public admin;

    struct Crisis {
        string type;        // e.g., "Debt", "Currency", "Political"
        string description;
        uint256 impactValue;
        uint256 timestamp;
    }

    Crisis[] public crises;

    event CrisisLogged(string type, string description, uint256 impactValue, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logCrisis(string calldata type, string calldata description, uint256 impactValue) external onlyAdmin {
        crises.push(Crisis(type, description, impactValue, block.timestamp));
        emit CrisisLogged(type, description, impactValue, block.timestamp);
    }

    function totalCrises() external view returns (uint256) {
        return crises.length;
    }

    function getCrisis(uint256 id) external view returns (Crisis memory) {
        require(id < crises.length, "Invalid id");
        return crises[id];
    }
}
