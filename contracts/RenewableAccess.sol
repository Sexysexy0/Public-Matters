// contracts/RenewableAccess.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RenewableAccess
 * @notice Logs communal access to renewable energy sources.
 */
contract RenewableAccess {
    address public admin;

    struct Source {
        string type;        // "Solar", "Wind", "Hydro"
        string status;      // "Available", "Limited", "Unavailable"
        uint256 capacity;   // in MW
        uint256 timestamp;
    }

    Source[] public sources;

    event SourceLogged(string type, string status, uint256 capacity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSource(string calldata type, string calldata status, uint256 capacity) external onlyAdmin {
        sources.push(Source(type, status, capacity, block.timestamp));
        emit SourceLogged(type, status, capacity, block.timestamp);
    }

    function totalSources() external view returns (uint256) { return sources.length; }

    function getSource(uint256 id) external view returns (Source memory) {
        require(id < sources.length, "Invalid id");
        return sources[id];
    }
}
