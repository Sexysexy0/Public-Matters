// contracts/AllianceAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AllianceAudit
 * @notice Tracks alliances and communal audit of commitments.
 */
contract AllianceAudit {
    address public admin;

    struct Alliance {
        string name;        // "NATO", "ASEAN", "QUAD"
        string status;      // "Stable", "Strained", "Expanding"
        uint256 timestamp;
    }

    Alliance[] public alliances;

    event AllianceLogged(string name, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAlliance(string calldata name, string calldata status) external onlyAdmin {
        alliances.push(Alliance(name, status, block.timestamp));
        emit AllianceLogged(name, status, block.timestamp);
    }

    function totalAlliances() external view returns (uint256) { return alliances.length; }

    function getAlliance(uint256 id) external view returns (Alliance memory) {
        require(id < alliances.length, "Invalid id");
        return alliances[id];
    }
}
