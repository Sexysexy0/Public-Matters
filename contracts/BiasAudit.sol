// contracts/BiasAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BiasAudit
 * @notice Communal audit of bias levels in media coverage.
 */
contract BiasAudit {
    address public admin;

    struct BiasRecord {
        string outlet;
        string category;   // "Political", "Economic", "Social"
        string rating;     // "Low", "Medium", "High"
        uint256 timestamp;
    }

    BiasRecord[] public biasRecords;

    event BiasLogged(string outlet, string category, string rating, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logBias(string calldata outlet, string calldata category, string calldata rating) external onlyAdmin {
        biasRecords.push(BiasRecord(outlet, category, rating, block.timestamp));
        emit BiasLogged(outlet, category, rating, block.timestamp);
    }

    function totalBiasRecords() external view returns (uint256) { return biasRecords.length; }

    function getBiasRecord(uint256 id) external view returns (BiasRecord memory) {
        require(id < biasRecords.length, "Invalid id");
        return biasRecords[id];
    }
}
