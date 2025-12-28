// contracts/InflationAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InflationAudit
 * @notice Tracks inflation pressures and communal affordability audits.
 */
contract InflationAudit {
    address public admin;

    struct Pressure {
        string factor;      // "Tariffs", "Healthcare", "Housing"
        string status;      // "High", "Moderate", "Low"
        uint256 timestamp;
    }

    Pressure[] public pressures;

    event PressureLogged(string factor, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logPressure(string calldata factor, string calldata status) external onlyAdmin {
        pressures.push(Pressure(factor, status, block.timestamp));
        emit PressureLogged(factor, status, block.timestamp);
    }

    function totalPressures() external view returns (uint256) { return pressures.length; }

    function getPressure(uint256 id) external view returns (Pressure memory) {
        require(id < pressures.length, "Invalid id");
        return pressures[id];
    }
}
