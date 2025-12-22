// contracts/CarbonAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CarbonAudit
 * @notice Communal audit of carbon emissions and reduction commitments.
 */
contract CarbonAudit {
    address public admin;

    struct Emission {
        string entity;
        uint256 tonsCO2;
        string status;   // "Reported", "Reduced", "Offset"
        uint256 timestamp;
    }

    Emission[] public emissions;

    event EmissionLogged(string entity, uint256 tonsCO2, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEmission(string calldata entity, uint256 tonsCO2, string calldata status) external onlyAdmin {
        emissions.push(Emission(entity, tonsCO2, status, block.timestamp));
        emit EmissionLogged(entity, tonsCO2, status, block.timestamp);
    }

    function totalEmissions() external view returns (uint256) { return emissions.length; }

    function getEmission(uint256 id) external view returns (Emission memory) {
        require(id < emissions.length, "Invalid id");
        return emissions[id];
    }
}
