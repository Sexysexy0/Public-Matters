// contracts/InfluenceAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InfluenceAudit
 * @notice Logs geopolitical influence arcs (China, US, UK, Mauritius).
 */
contract InfluenceAudit {
    address public admin;

    struct Influence {
        string actor;       // "China", "US", "Mauritius"
        string region;      // "Indian Ocean"
        string description;
        uint256 timestamp;
    }

    Influence[] public influences;

    event InfluenceLogged(string actor, string region, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logInfluence(string calldata actor, string calldata region, string calldata description) external onlyAdmin {
        influences.push(Influence(actor, region, description, block.timestamp));
        emit InfluenceLogged(actor, region, description, block.timestamp);
    }

    function totalInfluences() external view returns (uint256) { return influences.length; }

    function getInfluence(uint256 id) external view returns (Influence memory) {
        require(id < influences.length, "Invalid id");
        return influences[id];
    }
}
